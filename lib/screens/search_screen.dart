import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_state.dart';
import '../core/strings.dart';
import '../models/models.dart';
import '../services/news_api.dart';
import '../widgets/article_card.dart';
import '../widgets/async_states.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  Future<List<Article>>? _results;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      final q = value.trim();
      if (!mounted) return;
      setState(() {
        _query = q;
        _results = q.isEmpty
            ? null
            : NewsApi.getArticles(
          query: q,
          language: AppState.locale.value.languageCode,
        );
      });
    });
  }

  void _retry() {
    setState(() {
      _results = NewsApi.getArticles(
        query: _query,
        language: AppState.locale.value.languageCode,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? Colors.white : Colors.black;

    OutlineInputBorder border() => OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: fg, width: 1),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 14,
        centerTitle: false,
        title: SizedBox(
          height: 38,
          child: TextField(
            controller: _controller,
            onChanged: _onChanged,
            textInputAction: TextInputAction.search,
            style: GoogleFonts.inter(color: fg, fontSize: 12),
            cursorColor: fg,
            decoration: InputDecoration(
              hintText: S.of(context, 'search'),
              hintStyle: GoogleFonts.inter(color: fg, fontSize: 12),
              contentPadding: EdgeInsets.zero,
              prefixIcon: Icon(Icons.search, size: 18, color: fg),
              suffixIcon: IconButton(
                icon: Icon(Icons.close, size: 16, color: fg),
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    _controller.clear();
                    _debounce?.cancel();
                    setState(() {
                      _query = '';
                      _results = null;
                    });
                  } else if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              enabledBorder: border(),
              focusedBorder: border(),
              border: border(),
            ),
          ),
        ),
      ),
      body: _results == null
          ? Center(
        child: Text(
          S.of(context, 'type_to_search'),
          style: GoogleFonts.inter(fontSize: 13),
        ),
      )
          : FutureBuilder<List<Article>>(
        future: _results,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          if (snap.hasError) {
            return ErrorView(
              message: snap.error.toString(),
              onRetry: _retry,
            );
          }
          final articles = snap.data ?? [];
          if (articles.isEmpty) return const EmptyView();
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
            itemCount: articles.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => ArticleCard(article: articles[i]),
          );
        },
      ),
    );
  }
}





