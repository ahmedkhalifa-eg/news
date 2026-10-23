import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../core/app_theme.dart';
import '../models/models.dart';

/// Full article page: loads the publisher's page in a WebView (white page in
/// both themes, as in the design).
class ArticleDetailsScreen extends StatefulWidget {
  final Article article;

  const ArticleDetailsScreen({super.key, required this.article});

  @override
  State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  late final WebViewController _controller;
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (p) {
            if (mounted) setState(() => _progress = p);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.article.url));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.light(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            widget.article.sourceName,
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          bottom: _progress < 100
              ? PreferredSize(
            preferredSize: const Size.fromHeight(2),
            child: LinearProgressIndicator(
              value: _progress == 0 ? null : _progress / 100,
              minHeight: 2,
              color: Colors.black,
              backgroundColor: Colors.black12,
            ),
          )
              : null,
        ),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}