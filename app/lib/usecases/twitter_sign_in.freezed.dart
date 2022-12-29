// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'twitter_sign_in.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TwitterToken {
  String get token => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TwitterTokenCopyWith<TwitterToken> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TwitterTokenCopyWith<$Res> {
  factory $TwitterTokenCopyWith(
          TwitterToken value, $Res Function(TwitterToken) then) =
      _$TwitterTokenCopyWithImpl<$Res, TwitterToken>;
  @useResult
  $Res call({String token, String refreshToken});
}

/// @nodoc
class _$TwitterTokenCopyWithImpl<$Res, $Val extends TwitterToken>
    implements $TwitterTokenCopyWith<$Res> {
  _$TwitterTokenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? refreshToken = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TwitterTokenCopyWith<$Res>
    implements $TwitterTokenCopyWith<$Res> {
  factory _$$_TwitterTokenCopyWith(
          _$_TwitterToken value, $Res Function(_$_TwitterToken) then) =
      __$$_TwitterTokenCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token, String refreshToken});
}

/// @nodoc
class __$$_TwitterTokenCopyWithImpl<$Res>
    extends _$TwitterTokenCopyWithImpl<$Res, _$_TwitterToken>
    implements _$$_TwitterTokenCopyWith<$Res> {
  __$$_TwitterTokenCopyWithImpl(
      _$_TwitterToken _value, $Res Function(_$_TwitterToken) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? refreshToken = null,
  }) {
    return _then(_$_TwitterToken(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_TwitterToken implements _TwitterToken {
  const _$_TwitterToken({this.token = '', this.refreshToken = ''});

  @override
  @JsonKey()
  final String token;
  @override
  @JsonKey()
  final String refreshToken;

  @override
  String toString() {
    return 'TwitterToken(token: $token, refreshToken: $refreshToken)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TwitterToken &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @override
  int get hashCode => Object.hash(runtimeType, token, refreshToken);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TwitterTokenCopyWith<_$_TwitterToken> get copyWith =>
      __$$_TwitterTokenCopyWithImpl<_$_TwitterToken>(this, _$identity);
}

abstract class _TwitterToken implements TwitterToken {
  const factory _TwitterToken({final String token, final String refreshToken}) =
      _$_TwitterToken;

  @override
  String get token;
  @override
  String get refreshToken;
  @override
  @JsonKey(ignore: true)
  _$$_TwitterTokenCopyWith<_$_TwitterToken> get copyWith =>
      throw _privateConstructorUsedError;
}