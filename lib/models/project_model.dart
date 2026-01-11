class ProjectModel {
  final String? id;
  final String title;
  final String description;
  final String imagePath;
  final String? link;
  final DateTime createdAt;

  ProjectModel({
    this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    this.link,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert from JSON (Supabase response)
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imagePath: json['image_path'] ?? '',
      link: json['link'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  // Convert to JSON (for Supabase insert/update)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'image_path': imagePath,
      'link': link,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Copy with method for updates
  ProjectModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imagePath,
    String? link,
    DateTime? createdAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      link: link ?? this.link,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
