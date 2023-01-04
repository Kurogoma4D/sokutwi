// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fixed_phrases.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PhraseData {
  int get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PhraseDataCopyWith<PhraseData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhraseDataCopyWith<$Res> {
  factory $PhraseDataCopyWith(
          PhraseData value, $Res Function(PhraseData) then) =
      _$PhraseDataCopyWithImpl<$Res, PhraseData>;
  @useResult
  $Res call({int id, String text});
}

/// @nodoc
class _$PhraseDataCopyWithImpl<$Res, $Val extends PhraseData>
    implements $PhraseDataCopyWith<$Res> {
  _$PhraseDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PhraseDataCopyWith<$Res>
    implements $PhraseDataCopyWith<$Res> {
  factory _$$_PhraseDataCopyWith(
          _$_PhraseData value, $Res Function(_$_PhraseData) then) =
      __$$_PhraseDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String text});
}

/// @nodoc
class __$$_PhraseDataCopyWithImpl<$Res>
    extends _$PhraseDataCopyWithImpl<$Res, _$_PhraseData>
    implements _$$_PhraseDataCopyWith<$Res> {
  __$$_PhraseDataCopyWithImpl(
      _$_PhraseData _value, $Res Function(_$_PhraseData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
  }) {
    return _then(_$_PhraseData(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_PhraseData with DiagnosticableTreeMixin implements _PhraseData {
  const _$_PhraseData({required this.id, required this.text});

  @override
  final int id;
  @override
  final String text;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PhraseData(id: $id, text: $text)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PhraseData'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('text', text));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PhraseData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, text);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PhraseDataCopyWith<_$_PhraseData> get copyWith =>
      __$$_PhraseDataCopyWithImpl<_$_PhraseData>(this, _$identity);
}

abstract class _PhraseData implements PhraseData {
  const factory _PhraseData(
      {required final int id, required final String text}) = _$_PhraseData;

  @override
  int get id;
  @override
  String get text;
  @override
  @JsonKey(ignore: true)
  _$$_PhraseDataCopyWith<_$_PhraseData> get copyWith =>
      throw _privateConstructorUsedError;
}
