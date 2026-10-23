import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_state.dart';
import '../core/strings.dart';
import '../models/models.dart';
import '../services/news_api.dart';
import '../widgets/app_drawer.dart';
import '../widgets/article_card.dart';
import '../widgets/async_states.dart';
import 'search_screen.dart';

class CategoryScreen extends StatefulWidget {
  final NewsCategory category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<NewsSource>> _sources;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _sources = NewsApi.getSources(
      category: widget.category.id,
      language: AppState.locale.value.languageCode,
    );
  }

  AppBar _appBar(BuildContext context, {PreferredSizeWidget? bottom}) {
    return AppBar(
      title: Text(S.of(context, widget.category.id)),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const SearchScreen()),
          ),
        ),
      ],
      bottom: bottom,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? Colors.white : Colors.black;

    return FutureBuilder<List<NewsSource>>(
      future: _sources,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Scaffold(
            drawer: const AppDrawer(),
            appBar: _appBar(context),
            body: const LoadingView(),
          );
        }
        if (snap.hasError) {
          return Scaffold(
            drawer: const AppDrawer(),
            appBar: _appBar(context),
            body: ErrorView(
              message: snap.error.toString(),
              onRetry: () => setState(_load),
            ),
          );
        }
        final sources = snap.data ?? [];
        if (sources.isEmpty) {
          return Scaffold(
            drawer: const AppDrawer(),
            appBar: _appBar(context),
            body: const EmptyView(),
          );
        }

        return DefaultTabController(
          length: sources.length,
          child: Scaffold(
            drawer: const AppDrawer(),
            appBar: _appBar(
              context,
              bottom: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.transparent,
                indicatorColor: fg,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 1.5,
                labelColor: fg,
                unselectedLabelColor: fg.withValues(alpha: 0.6),
                labelStyle: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [for (final s in sources) Tab(text: s.name, height: 34)],
              ),
            ),
            body: TabBarView(
              children: [
                for (final s in sources) _SourceArticles(sourceId: s.id),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Articles of one source; loaded lazily and kept alive between tab switches.
class _SourceArticles extends StatefulWidget {
  final String sourceId;

  const _SourceArticles({required this.sourceId});

  @override
  State<_SourceArticles> createState() => _SourceArticlesState();
}

class _SourceArticlesState extends State<_SourceArticles>
    with AutomaticKeepAliveClientMixin {
  late Future<List<Article>> _articles;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _articles = NewsApi.getArticles(sourceId: widget.sourceId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Article>>(
      future: _articles,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const LoadingView();
        }
        if (snap.hasError) {
          return ErrorView(
            message: snap.error.toString(),
            onRetry: () => setState(_load),
          );
        }
        final articles = snap.data ?? [];
        if (articles.isEmpty) return const EmptyView();

        return RefreshIndicator(
          onRefresh: () async {
            setState(_load);
            await _articles;
          },
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
            itemCount: articles.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => ArticleCard(article: articles[i]),
          ),
        );
      },
    );
  }
}