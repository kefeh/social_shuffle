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
      howToPlay: fields[8] as HowToPlay?,
    );
  }

  @override
  void write(BinaryWriter writer, Deck obj) {
    writer
      ..writeByte(9)
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
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.howToPlay);
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

class HowToPlayAdapter extends TypeAdapter<HowToPlay> {
  @override
  final int typeId = 2;

  @override
  HowToPlay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HowToPlay(
      description: fields[0] as String,
      steps: (fields[1] as List).cast<InstructionStep>(),
    );
  }

  @override
  void write(BinaryWriter writer, HowToPlay obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.description)
      ..writeByte(1)
      ..write(obj.steps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HowToPlayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InstructionStepAdapter extends TypeAdapter<InstructionStep> {
  @override
  final int typeId = 3;

  @override
  InstructionStep read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InstructionStep(
      title: fields[0] as String,
      description: fields[1] as String,
      iconName: fields[2] as String,
      colorHex: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, InstructionStep obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.iconName)
      ..writeByte(3)
      ..write(obj.colorHex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstructionStepAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
