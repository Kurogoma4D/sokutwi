// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_tweet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TweetResult<R> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() success,
    required TResult Function(TweetFailKind kind) fail,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? success,
    TResult? Function(TweetFailKind kind)? fail,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? success,
    TResult Function(TweetFailKind kind)? fail,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TweetSuccess<R> value) success,
    required TResult Function(TweetFail<R> value) fail,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TweetSuccess<R> value)? success,
    TResult? Function(TweetFail<R> value)? fail,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TweetSuccess<R> value)? success,
    TResult Function(TweetFail<R> value)? fail,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TweetResultCopyWith<R, $Res> {
  factory $TweetResultCopyWith(
          TweetResult<R> value, $Res Function(TweetResult<R>) then) =
      _$TweetResultCopyWithImpl<R, $Res, TweetResult<R>>;
}

/// @nodoc
class _$TweetResultCopyWithImpl<R, $Res, $Val extends TweetResult<R>>
    implements $TweetResultCopyWith<R, $Res> {
  _$TweetResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$TweetSuccessCopyWith<R, $Res> {
  factory _$$TweetSuccessCopyWith(
          _$TweetSuccess<R> value, $Res Function(_$TweetSuccess<R>) then) =
      __$$TweetSuccessCopyWithImpl<R, $Res>;
}

/// @nodoc
class __$$TweetSuccessCopyWithImpl<R, $Res>
    extends _$TweetResultCopyWithImpl<R, $Res, _$TweetSuccess<R>>
    implements _$$TweetSuccessCopyWith<R, $Res> {
  __$$TweetSuccessCopyWithImpl(
      _$TweetSuccess<R> _value, $Res Function(_$TweetSuccess<R>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$TweetSuccess<R>
    with DiagnosticableTreeMixin
    implements TweetSuccess<R> {
  const _$TweetSuccess();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'TweetResult<$R>.success()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'TweetResult<$R>.success'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TweetSuccess<R>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() success,
    required TResult Function(TweetFailKind kind) fail,
  }) {
    return success();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? success,
    TResult? Function(TweetFailKind kind)? fail,
  }) {
    return success?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? success,
    TResult Function(TweetFailKind kind)? fail,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TweetSuccess<R> value) success,
    required TResult Function(TweetFail<R> value) fail,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TweetSuccess<R> value)? success,
    TResult? Function(TweetFail<R> value)? fail,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TweetSuccess<R> value)? success,
    TResult Function(TweetFail<R> value)? fail,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class TweetSuccess<R> implements TweetResult<R> {
  const factory TweetSuccess() = _$TweetSuccess<R>;
}

/// @nodoc
abstract class _$$TweetFailCopyWith<R, $Res> {
  factory _$$TweetFailCopyWith(
          _$TweetFail<R> value, $Res Function(_$TweetFail<R>) then) =
      __$$TweetFailCopyWithImpl<R, $Res>;
  @useResult
  $Res call({TweetFailKind kind});
}

/// @nodoc
class __$$TweetFailCopyWithImpl<R, $Res>
    extends _$TweetResultCopyWithImpl<R, $Res, _$TweetFail<R>>
    implements _$$TweetFailCopyWith<R, $Res> {
  __$$TweetFailCopyWithImpl(
      _$TweetFail<R> _value, $Res Function(_$TweetFail<R>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
  }) {
    return _then(_$TweetFail<R>(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as TweetFailKind,
    ));
  }
}

/// @nodoc

class _$TweetFail<R> with DiagnosticableTreeMixin implements TweetFail<R> {
  const _$TweetFail({required this.kind});

  @override
  final TweetFailKind kind;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'TweetResult<$R>.fail(kind: $kind)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'TweetResult<$R>.fail'))
      ..add(DiagnosticsProperty('kind', kind));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TweetFail<R> &&
            (identical(other.kind, kind) || other.kind == kind));
  }

  @override
  int get hashCode => Object.hash(runtimeType, kind);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TweetFailCopyWith<R, _$TweetFail<R>> get copyWith =>
      __$$TweetFailCopyWithImpl<R, _$TweetFail<R>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() success,
    required TResult Function(TweetFailKind kind) fail,
  }) {
    return fail(kind);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? success,
    TResult? Function(TweetFailKind kind)? fail,
  }) {
    return fail?.call(kind);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? success,
    TResult Function(TweetFailKind kind)? fail,
    required TResult orElse(),
  }) {
    if (fail != null) {
      return fail(kind);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TweetSuccess<R> value) success,
    required TResult Function(TweetFail<R> value) fail,
  }) {
    return fail(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TweetSuccess<R> value)? success,
    TResult? Function(TweetFail<R> value)? fail,
  }) {
    return fail?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TweetSuccess<R> value)? success,
    TResult Function(TweetFail<R> value)? fail,
    required TResult orElse(),
  }) {
    if (fail != null) {
      return fail(this);
    }
    return orElse();
  }
}

abstract class TweetFail<R> implements TweetResult<R> {
  const factory TweetFail({required final TweetFailKind kind}) = _$TweetFail<R>;

  TweetFailKind get kind;
  @JsonKey(ignore: true)
  _$$TweetFailCopyWith<R, _$TweetFail<R>> get copyWith =>
      throw _privateConstructorUsedError;
}
