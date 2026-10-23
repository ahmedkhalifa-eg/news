import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/strings.dart';
import '../data/categories.dart';
import '../widgets/app_drawer.dart';
import '../widgets/category_card.dart';
import 'category_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const categories = kCategories;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(S.of(context, 'home')),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SearchScreen()),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                S.of(context, 'greeting'),
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                ),
              ),
            );
          }
          final category = categories[i - 1];
          return CategoryCard(
            category: category,
            imageFirst: (i - 1).isEven,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => CategoryScreen(category: category),
              ),
            ),
          );
        },
      ),
    );
  }
}