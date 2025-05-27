class Task {
  String title;
  bool isDone;

  Task({required this.title, this.isDone = false});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      isDone: json['isDone'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'isDone': isDone,
      };
}
