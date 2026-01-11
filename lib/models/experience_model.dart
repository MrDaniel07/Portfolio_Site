class ExperienceModel {
  final String? id;
  final String title;
  final String company;
  final String period;
  final List<String> responsibilities;
  final String imagePath;
  final DateTime createdAt;

  ExperienceModel({
    this.id,
    required this.title,
    required this.company,
    required this.period,
    required this.responsibilities,
    this.imagePath = 'assets/images/default_company.png',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert from JSON (Supabase response)
  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      period: json['period'] ?? '',
      responsibilities: json['responsibilities'] != null
          ? List<String>.from(json['responsibilities'])
          : [],
      imagePath: json['image_path'] ?? 'assets/images/default_company.png',
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
      'company': company,
      'period': period,
      'responsibilities': responsibilities,
      'image_path': imagePath,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Copy with method for updates
  ExperienceModel copyWith({
    String? id,
    String? title,
    String? company,
    String? period,
    List<String>? responsibilities,
    String? imagePath,
    DateTime? createdAt,
  }) {
    return ExperienceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      period: period ?? this.period,
      responsibilities: responsibilities ?? this.responsibilities,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
