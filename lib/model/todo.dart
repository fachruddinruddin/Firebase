class Todo {
  final String uid;
  final String title;
  final String description;
  final bool isComplete;

  Todo({
    required this.uid,
    required this.title,
    required this.description,
    required this.isComplete,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'title': title,
      'description': description,
      'isComplete': isComplete,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      uid: map['uid'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      isComplete: map['isComplete'] as bool,
    );
  }
}