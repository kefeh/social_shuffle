import 'package:hive/hive.dart';
import 'package:social_shuffle/core/models/card.dart';
import 'package:uuid/uuid.dart';

part 'deck.g.dart';

@HiveType(typeId: 1)
class Deck {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String gameEngineId;
  @HiveField(3)
  final String gameEngineType;
  @HiveField(4)
  final bool isSystem;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final List<Card> cards;
  @HiveField(7)
  final String? description;
  @HiveField(8)
  final HowToPlay? howToPlay;

  Deck({
    String? id,
    required this.title,
    required this.gameEngineId,
    required this.gameEngineType,
    this.isSystem = false,
    DateTime? createdAt,
    required this.cards,
    this.description,
    this.howToPlay,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  factory Deck.fromJson(Map<String, dynamic> json) {
    return Deck(
      id: json['id'] as String?,
      title: json['title'] as String,
      gameEngineId: json['game_engine_id'] as String,
      gameEngineType: json['game_engine_type'] as String? ?? 'default',
      isSystem: json['is_system'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      cards: (json['cards'] as List<dynamic>)
          .map((e) => Card.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String?,
      howToPlay: json['how_to_play'] != null
          ? HowToPlay.fromJson(json['how_to_play'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'game_engine_id': gameEngineId,
      'game_engine_type': gameEngineType,
      'is_system': isSystem,
      'created_at': createdAt.toIso8601String(),
      'cards': cards.map((e) => e.toJson()).toList(),
      'description': description,
      'how_to_play': howToPlay?.toJson(),
    };
  }
}

@HiveType(typeId: 2)
class HowToPlay {
  @HiveField(0)
  final String description;
  @HiveField(1)
  final List<InstructionStep> steps;

  HowToPlay({required this.description, required this.steps});

  factory HowToPlay.fromJson(Map<String, dynamic> json) {
    return HowToPlay(
      description: json['description'] as String? ?? '',
      steps:
          (json['steps'] as List<dynamic>?)
              ?.map((e) => InstructionStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'steps': steps.map((e) => e.toJson()).toList(),
    };
  }
}

@HiveType(typeId: 3)
class InstructionStep {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final String iconName;
  @HiveField(3)
  final String colorHex;

  InstructionStep({
    required this.title,
    required this.description,
    required this.iconName,
    required this.colorHex,
  });

  factory InstructionStep.fromJson(Map<String, dynamic> json) {
    return InstructionStep(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      iconName: json['icon_name'] as String? ?? 'help_outline',
      colorHex: json['color_hex'] as String? ?? '#FFFFFF',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'icon_name': iconName,
      'color_hex': colorHex,
    };
  }
}
