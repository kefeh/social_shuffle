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
  final bool isSystem;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  final List<Card> cards;

  Deck({
    String? id,
    required this.title,
    required this.gameEngineId,
    this.isSystem = false,
    DateTime? createdAt,
    required this.cards,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  factory Deck.fromJson(Map<String, dynamic> json) {
    return Deck(
      id: json['id'] as String?,
      title: json['title'] as String,
      gameEngineId: json['game_engine_id'] as String,
      isSystem: json['is_system'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      cards: (json['cards'] as List<dynamic>)
          .map((e) => Card.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'game_engine_id': gameEngineId,
      'is_system': isSystem,
      'created_at': createdAt.toIso8601String(),
      'cards': cards.map((e) => e.toJson()).toList(),
    };
  }
}
