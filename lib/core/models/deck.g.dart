// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeckAdapter extends TypeAdapter<Deck> {
  @override
  final int typeId = 1;

  @override
  Deck read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Deck(
      id: fields[0] as String?,
      title: fields[1] as String,
      gameEngineId: fields[2] as String,
      gameEngineType: fields[3] as String,
      isSystem: fields[4] as bool,
      createdAt: fields[5] as DateTime?,
      cards: (fields[6] as List).cast<Card>(),
      description: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Deck obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.gameEngineId)
      ..writeByte(3)
      ..write(obj.gameEngineType)
      ..writeByte(4)
      ..write(obj.isSystem)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.cards)
      ..writeByte(7)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
