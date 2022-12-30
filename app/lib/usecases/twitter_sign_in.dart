import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sokutwi/constants/constants.dart';
import 'package:sokutwi/constants/environment_config.dart';
import 'package:twitter_oauth2_pkce/twitter_oauth2_pkce.dart' as auth;

part 'twitter_sign_in.freezed.dart';

class UnauthorizedError implements Exception {}

@freezed
class TwitterToken with _$TwitterToken {
  const factory TwitterToken({
    @Default('') String token,
    @Default('') String refreshToken,
  }) = _TwitterToken;
}

final authTokenStore =
    StateProvider<AsyncValue<TwitterToken>>((_) => const AsyncLoading());

final twitterSignInUsecase = Provider((ref) {
  return () async {
    final authClient = auth.TwitterOAuth2Client(
      clientId: Env.twitterClientId,
      clientSecret: Env.twitterClientSecret,
      redirectUri: twitterRedirectUri,
      customUriScheme: appCustomUrlScheme,
    );

    final controller = ref.watch(authTokenStore.notifier);

    try {
      final response = await authClient.executeAuthCodeFlowWithPKCE(
        scopes: [auth.Scope.blockWrite],
      );

      if (response.accessToken.isEmpty) {
        controller.state = AsyncError(UnauthorizedError(), StackTrace.current);
        return true;
      }

      controller.state = AsyncData(TwitterToken(
        token: response.accessToken,
        refreshToken: response.refreshToken ?? '',
      ));
    } catch (error) {
      controller.state = AsyncError(error, StackTrace.current);
    }

    return false;
  };
});

// TODO: refresh token

// TODO: persistant token