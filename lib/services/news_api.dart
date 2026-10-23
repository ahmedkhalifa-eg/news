import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/config.dart';
import '../models/models.dart';

class NewsApiException implements Exception {
  final String message;
  const NewsApiException(this.message);

  @override
  String toString() => message;
}

/// Thin client for https://newsapi.org (v2).
///
/// Provide your key at build/run time:
///   flutter run --dart-define=NEWS_API_KEY=your_key_here
class NewsApi {
  NewsApi._();

  static const String _envKey = String.fromEnvironment('NEWS_API_KEY');

  /// --dart-define value if provided, otherwise the key from config.dart.
  static String get _apiKey {
    final fromEnv = _envKey.trim();
    return fromEnv.isNotEmpty ? fromEnv : kNewsApiKey.trim();
  }
  static const String _host = 'newsapi.org';

  static Future<Map<String, dynamic>> _get(
      String path,
      Map<String, String> query,
      ) async {
    if (_apiKey.isEmpty) {
      throw const NewsApiException(
        'Missing API key. Paste it in lib/core/config.dart or run with --dart-define=NEWS_API_KEY=YOUR_KEY',
      );
    }

    final uri = Uri.https(_host, '/v2/$path', {...query, 'apiKey': _apiKey});

    try {
      final res = await http.get(uri).timeout(const Duration(seconds: 20));
      final body = jsonDecode(utf8.decode(res.bodyBytes));
      if (body is! Map<String, dynamic>) {
        throw const NewsApiException('Unexpected server response');
      }
      if (res.statusCode != 200 || body['status'] != 'ok') {
        throw NewsApiException(
          (body['message'] ?? 'Request failed (${res.statusCode})').toString(),
        );
      }
      return body;
    } on TimeoutException {
      throw const NewsApiException('Request timed out. Check your connection.');
    } on http.ClientException {
      throw const NewsApiException('No internet connection.');
    } on FormatException {
      throw const NewsApiException('Could not read server response.');
    }
  }

  /// Sources available for a category (e.g. ABC News, Axios...).
  static Future<List<NewsSource>> getSources({
    required String category,
    required String language,
  }) async {
    final body = await _get('top-headlines/sources', {
      'category': category,
      'language': language,
    });
    return (body['sources'] as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(NewsSource.fromJson)
        .where((s) => s.id.isNotEmpty)
        .toList();
  }

  /// Articles for a given source id, or for a free-text search [query].
  static Future<List<Article>> getArticles({
    String? sourceId,
    String? query,
    String? language,
    int pageSize = 20,
  }) async {
    final params = <String, String>{
      'pageSize': '$pageSize',
      'sortBy': 'publishedAt',
    };
    if (sourceId != null) params['sources'] = sourceId;
    if (query != null) {
      params['q'] = query;
      if (language != null) params['language'] = language;
    }

    final body = await _get('everything', params);
    return (body['articles'] as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(Article.fromJson)
        .where((a) => a.isValid)
        .toList();
  }
}