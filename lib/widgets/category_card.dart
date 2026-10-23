import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_theme.dart';
import '../core/strings.dart';
import '../models/models.dart';
import 'app_image.dart';

class CategoryCard extends StatelessWidget {
  final NewsCategory category;

  /// When true the image sits at the leading side and the arrow button at the
  /// trailing side; otherwise the layout is mirrored (as in the design).
  final bool imageFirst;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.imageFirst,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? Colors.white : AppColors.ink;
    final textColor = isDark ? Colors.black : Colors.white;
    final circleBg = isDark ? AppColors.ink : Colors.white;
    final circleFg = isDark ? Colors.white : Colors.black;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final image = Expanded(
      flex: 5,
      child: AppImage.asset(
        category.imageAsset,
        height: double.infinity,
        fallbackIcon: Icons.public,
      ),
    );

    final forwardIcon =
    isRtl ? Icons.arrow_back_ios_new_rounded : Icons.arrow_forward_ios_rounded;
    final backIcon =
    isRtl ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded;

    Widget circle(IconData icon) => Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(color: circleBg, shape: BoxShape.circle),
      child: Icon(icon, size: 14, color: circleFg),
    );

    final label = Text(
      S.of(context, 'view_all'),
      style: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );

    final pill = Container(
      height: 34,
      decoration: BoxDecoration(
        color: AppColors.pill,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: imageFirst
            ? [
          const SizedBox(width: 14),
          label,
          const SizedBox(width: 10),
          circle(forwardIcon),
        ]
            : [
          circle(backIcon),
          const SizedBox(width: 10),
          label,
          const SizedBox(width: 14),
        ],
      ),
    );

    final content = Expanded(
      flex: 6,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
        child: Column(
          crossAxisAlignment:
          imageFirst ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Align(
              alignment:
              imageFirst ? Alignment.center : AlignmentDirectional.centerStart,
              child: Text(
                S.of(context, category.id),
                style: GoogleFonts.inter(
                  color: textColor,
                  fontSize: imageFirst ? 22 : 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Spacer(),
            Align(
              alignment: imageFirst
                  ? AlignmentDirectional.centerEnd
                  : AlignmentDirectional.centerStart,
              child: pill,
            ),
          ],
        ),
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          children: imageFirst ? [image, content] : [content, image],
        ),
      ),
    );
  }
}