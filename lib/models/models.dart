class NewsCategory {
  final String id; // NewsAPI category id, also the localisation key
  final String imageAsset;

  const NewsCategory({required this.id, required this.imageAsset});
}

class NewsSource {
  final String id;
  final String name;

  const NewsSource({required this.id, required this.name});

  factory NewsSource.fromJson(Map<String, dynamic> json) => NewsSource(
    id: (json['id'] ?? '').toString(),
    name: (json['name'] ?? '').toString(),
  );
}

class Article {
  final String title;
  final String description;
  final String author;
  final String sourceName;
  final String url;
  final String? imageUrl;
  final DateTime? publishedAt;

  const Article({
    required this.title,
    required this.description,
    required this.author,
    required this.sourceName,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    final source = json['source'];
    final sourceName =
    source is Map ? (source['name'] ?? '').toString() : '';
    final author = (json['author'] ?? '').toString().trim();
    return Article(
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      author: author.isEmpty ? sourceName : author,
      sourceName: sourceName,
      url: (json['url'] ?? '').toString(),
      imageUrl: json['urlToImage']?.toString(),
      publishedAt: DateTime.tryParse((json['publishedAt'] ?? '').toString()),
    );
  }

  /// NewsAPI returns removed articles with this placeholder title.
  bool get isValid =>
      title.isNotEmpty && title != '[Removed]' && url.startsWith('http');
}