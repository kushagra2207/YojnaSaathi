class Scheme {
  final int id;
  final String title;
  final String description;
  final String eligibility;
  final String documentsRequired;
  final String whereToApply;
  final String category;
  final String createdAt;
  final String updatedAt;

  Scheme({
    required this.id,
    required this.title,
    required this.description,
    required this.eligibility,
    required this.documentsRequired,
    required this.whereToApply,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) {
    return Scheme(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      eligibility: json['eligibility'] as String? ?? '',
      documentsRequired: json['documents_required'] as String? ?? '',
      whereToApply: json['where_to_apply'] as String? ?? '',
      category: json['category'] as String? ?? 'other',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'eligibility': eligibility,
      'documents_required': documentsRequired,
      'where_to_apply': whereToApply,
      'category': category,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory Scheme.fromDb(Map<String, dynamic> map) {
    return Scheme(
      id: map['id'] as int,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      eligibility: map['eligibility'] as String? ?? '',
      documentsRequired: map['documents_required'] as String? ?? '',
      whereToApply: map['where_to_apply'] as String? ?? '',
      category: map['category'] as String? ?? 'other',
      createdAt: map['created_at'] as String? ?? '',
      updatedAt: map['updated_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toDb() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'eligibility': eligibility,
      'documents_required': documentsRequired,
      'where_to_apply': whereToApply,
      'category': category,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
