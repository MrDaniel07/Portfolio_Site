class SettingsModel {
  final String? id;
  final String adminPassword;
  final String seoTitle;
  final String seoDescription;
  final String seoKeywords;
  final String seoAuthor;
  final String seoOgImage;
  final DateTime updatedAt;

  SettingsModel({
    this.id,
    required this.adminPassword,
    required this.seoTitle,
    required this.seoDescription,
    required this.seoKeywords,
    required this.seoAuthor,
    required this.seoOgImage,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  // Convert from JSON (Supabase response)
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      id: json['id']?.toString(),
      adminPassword: json['admin_password'] ?? 'admin123',
      seoTitle: json['seo_title'] ?? 'Anyahuru Oluebube Daniel - Portfolio',
      seoDescription: json['seo_description'] ??
          'Software Engineer and Cloud Security Engineer specializing in application development and cybersecurity',
      seoKeywords: json['seo_keywords'] ??
          'software engineer, cloud security, cybersecurity, flutter developer, AWS, portfolio',
      seoAuthor: json['seo_author'] ?? 'Anyahuru Oluebube Daniel',
      seoOgImage: json['seo_og_image'] ?? '',
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  // Convert to JSON (for Supabase insert/update)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'admin_password': adminPassword,
      'seo_title': seoTitle,
      'seo_description': seoDescription,
      'seo_keywords': seoKeywords,
      'seo_author': seoAuthor,
      'seo_og_image': seoOgImage,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Copy with method for updates
  SettingsModel copyWith({
    String? id,
    String? adminPassword,
    String? seoTitle,
    String? seoDescription,
    String? seoKeywords,
    String? seoAuthor,
    String? seoOgImage,
    DateTime? updatedAt,
  }) {
    return SettingsModel(
      id: id ?? this.id,
      adminPassword: adminPassword ?? this.adminPassword,
      seoTitle: seoTitle ?? this.seoTitle,
      seoDescription: seoDescription ?? this.seoDescription,
      seoKeywords: seoKeywords ?? this.seoKeywords,
      seoAuthor: seoAuthor ?? this.seoAuthor,
      seoOgImage: seoOgImage ?? this.seoOgImage,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
