import 'package:hive/hive.dart';

part 'card.g.dart';

@HiveType(typeId: 0)
class Card {
  @HiveField(0)
  final String content;
  @HiveField(1)
  final List<String>? options;
  @HiveField(2)
  final int? correctIndex;
  @HiveField(3)
  final Map<String, dynamic>? meta;

  Card({
    required this.content,
    this.options,
    this.correctIndex,
    this.meta,
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      content: json['content'] as String,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      correctIndex: json['correct_index'] as int?,
      meta: json['meta'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'options': options,
      'correct_index': correctIndex,
      'meta': meta,
    };
  }
}
