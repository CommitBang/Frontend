class Metadata {
  final String title;
  final String author;
  final int pages;

  const Metadata({
    required this.title,
    required this.author,
    required this.pages,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      title: json['title'] as String,
      author: json['author'] as String,
      pages: (json['pages'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'author': author, 'pages': pages};
  }
}
