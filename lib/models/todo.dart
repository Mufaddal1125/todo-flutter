class Todo {
  int? id;
  String title;
  bool completed;
  DateTime? reminder;
  DateTime? createdAt;
  DateTime? updatedAt;

  Todo({
    required this.title,
    required this.completed,
    this.id,
    this.reminder,
    this.createdAt,
    this.updatedAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'] ?? '',
      completed: json['completed'],
      reminder: DateTime.tryParse(json['reminder'] ?? ''),
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
      'reminder': reminder?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
