class Note {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String createdAt;
  final String updatedAt;
  final String? imagePath;
  final String? category;
  final String? color;
  final bool isPinned;
  
  Note({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.imagePath,
    this.category,
    this.color,
    this.isPinned = false,
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
      category: json['category'],
      color: json['color'],
      isPinned: json['pinned'] ?? json['isPinned'] ?? false,
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
      'category': category,
      'color': color,
      'isPinned': isPinned,
    };
  }
}
