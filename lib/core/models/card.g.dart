// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CardAdapter extends TypeAdapter<Card> {
  @override
  final int typeId = 0;

  @override
  Card read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Card(
      content: fields[0] as String,
      back: fields[1] as String?,
      options: (fields[2] as List?)?.cast<String>(),
      correctIndex: fields[3] as int?,
      meta: (fields[4] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Card obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.content)
      ..writeByte(1)
      ..write(obj.back)
      ..writeByte(2)
      ..write(obj.options)
      ..writeByte(3)
      ..write(obj.correctIndex)
      ..writeByte(4)
      ..write(obj.meta);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
