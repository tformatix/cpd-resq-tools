class EuroRescueResultDocument {
  final String url;
  final String language;
  final String type;

  EuroRescueResultDocument({
    required this.url,
    required this.language,
    required this.type,
  });

  factory EuroRescueResultDocument.fromJson(Map<String, dynamic> json) {
    return EuroRescueResultDocument(
      language: json['language'],
      type: json['type'],
      url: json['url'],
    );
  }
}
