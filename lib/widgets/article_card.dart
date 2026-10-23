import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_theme.dart';
import '../core/strings.dart';
import '../models/models.dart';
import '../screens/article_details_screen.dart';
import 'app_image.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () => showArticleSheet(context, article),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: fg.withValues(alpha: 0.75), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppImage.network(
              article.imageUrl,
              height: 150,
              width: double.infinity,
              radius: 10,
            ),
            const SizedBox(height: 8),
            Text(
              article.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: fg,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${S.of(context, 'by')} : ${article.author}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: AppColors.muted,
                      fontSize: 9,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  S.timeAgo(context, article.publishedAt),
                  style: GoogleFonts.inter(
                    color: AppColors.muted,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom card shown when an article is tapped, with a "View Full Article"
/// button that opens the article page.
void showArticleSheet(BuildContext context, Article article) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final fg = isDark ? Colors.white : Colors.black;
  final bg = isDark ? AppColors.darkBg : Colors.white;

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: fg, width: 1.5),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppImage.network(
                  article.imageUrl,
                  height: 170,
                  width: double.infinity,
                  radius: 10,
                ),
                const SizedBox(height: 10),
                Text(
                  article.description.isEmpty
                      ? article.title
                      : article.description,
                  style: GoogleFonts.inter(
                    color: fg,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: fg,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ArticleDetailsScreen(article: article),
                        ),
                      );
                    },
                    child: Text(
                      S.of(context, 'view_full_article'),
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}