class Language {
  final String code;
  final String name;
  final String nativeName;

  Language({
    required this.code,
    required this.name,
    required this.nativeName,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      code: json['code'] as String,
      name: json['name'] as String,
      nativeName: json['nativeName'] as String,
    );
  }
}
