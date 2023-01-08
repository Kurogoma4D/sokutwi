import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sokutwi/constants/constants.dart';
import 'package:sokutwi/constants/environment_config.dart';
import 'package:sokutwi/constants/exceptions.dart';
import 'package:sokutwi/datasources/secure_storage.dart';
import 'package:twitter_oauth2_pkce/twitter_oauth2_pkce.dart' as auth;
import 'package:twitter_api_v2/twitter_api_v2.dart' as v2;

part 'twitter_sign_in.freezed.dart';

const _tokenKey = 'token';
const _refreshTokenKey = 'refreshToken';
const _expireAtKey = 'expireAt';

@freezed
class TwitterToken with _$TwitterToken {
  const TwitterToken._();
  const factory TwitterToken({
    @Default('') String token,
    @Default('') String refreshToken,
    @Default(0) int expireAt,
  }) = _TwitterToken;

  bool get isValid => token.isNotEmpty && refreshToken.isNotEmpty;
}

final authTokenStore =
    StateProvider<AsyncValue<TwitterToken>>((_) => const AsyncLoading());

final tryObtainAuthToken = Provider.autoDispose((ref) {
  return () async {
    final controller = ref.read(authTokenStore.notifier);
    final cachedToken = await ref.read(obtainCachedAuthToken.future);
    if (cachedToken.isValid) {
      controller.state = AsyncData(cachedToken);
    }

    if (cachedToken.expireAt < DateTime.now().millisecondsSinceEpoch) {
      ref.read(refreshAuthToken)(cachedToken.refreshToken);
    }
  };
});

final isAlreadySignedIn = Provider.autoDispose(
    (ref) => ref.watch(authTokenStore).asData?.value.token.isNotEmpty ?? false);

final twitterSignInUsecase = Provider.autoDispose((ref) {
  final controller = ref.watch(authTokenStore.notifier);

  return () async {
    final authClient = auth.TwitterOAuth2Client(
      clientId: Env.twitterClientId,
      clientSecret: Env.twitterClientSecret,
      redirectUri: twitterRedirectUri,
      customUriScheme: appCustomUrlScheme,
    );

    try {
      final response = await authClient.executeAuthCodeFlowWithPKCE(
        scopes: [
          auth.Scope.tweetWrite,
          auth.Scope.tweetRead,
          auth.Scope.usersRead,
          auth.Scope.offlineAccess,
        ],
      );

      if (response.accessToken.isEmpty) {
        controller.state = AsyncError(
          const UnauthorizedError(),
          StackTrace.current,
        );
        return false;
      }

      final data = TwitterToken(
        token: response.accessToken,
        refreshToken: response.refreshToken ?? '',
        expireAt: response.expireAt.millisecondsSinceEpoch,
      );
      await ref.read(_persistentAuthToken)(data);

      controller.state = AsyncData(data);
      return true;
    } catch (error) {
      controller.state = AsyncError(error, StackTrace.current);
    }

    return false;
  };
});

final twitterSignOutUsecase = Provider.autoDispose((ref) {
  final controller = ref.watch(authTokenStore.notifier);
  final storage = ref.watch(secureStorage);
  return () {
    storage.deleteAll();
    controller.state = const AsyncData(TwitterToken());
  };
});

final refreshAuthToken = Provider.autoDispose((ref) {
  final controller = ref.watch(authTokenStore.notifier);

  return (String token) async {
    if (token.isEmpty) return;

    final response = await v2.OAuthUtils.refreshAccessToken(
      clientId: Env.twitterClientId,
      clientSecret: Env.twitterClientSecret,
      refreshToken: token,
    );

    if (response.accessToken.isEmpty) {
      controller.state = AsyncError(
        const UnauthorizedError(),
        StackTrace.current,
      );
      return;
    }

    final data = TwitterToken(
      token: response.accessToken,
      refreshToken: response.refreshToken,
      expireAt: response.expiresAt.millisecondsSinceEpoch,
    );
    await ref.read(_persistentAuthToken)(data);

    controller.state = AsyncData(data);
    return;
  };
});

final _persistentAuthToken = Provider.autoDispose((ref) {
  final storage = ref.watch(secureStorage);
  return (TwitterToken data) async {
    await storage.write(key: _tokenKey, value: data.token);
    await storage.write(key: _refreshTokenKey, value: data.refreshToken);
    await storage.write(key: _expireAtKey, value: '${data.expireAt}');
  };
});

final obtainCachedAuthToken = FutureProvider((ref) async {
  final storage = ref.watch(secureStorage);
  final token = await storage.read(key: _tokenKey);
  final refreshToken = await storage.read(key: _refreshTokenKey);
  final expireAt = await storage.read(key: _expireAtKey);

  return TwitterToken(
    token: token ?? '',
    refreshToken: refreshToken ?? '',
    expireAt: int.tryParse(expireAt ?? '') ?? 0,
  );
});
