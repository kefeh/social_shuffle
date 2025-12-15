class Card {
  final String content;
  final List<String>? options;
  final int? correctIndex;
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
