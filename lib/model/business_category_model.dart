class BusinessCategory {
  final int id;
  final String name;
  final String description;
  // Add other fields as needed

  BusinessCategory({
    required this.id,
    required this.name,
    required this.description,
  });

  factory BusinessCategory.fromJson(Map<String, dynamic> json) {
    return BusinessCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
