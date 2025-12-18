class Note {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String createdAt;
  final String updatedAt;
  final String? imagePath;
  
  Note({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.imagePath,
  });
  
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'].toString(),
      userId: json['userId'].toString(),
      title: json['title'],
      content: json['content'],
      // Parse Spring Boot's LocalDateTime format (ISO 8601)
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
      imagePath: json['imagePath'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'imagePath': imagePath,
    };
  }
}
