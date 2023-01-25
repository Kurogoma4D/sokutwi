// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phrase.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PhraseAdapter extends TypeAdapter<Phrase> {
  @override
  final int typeId = 0;

  @override
  Phrase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Phrase(
      text: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Phrase obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.text);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhraseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
