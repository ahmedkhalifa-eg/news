import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_state.dart';
import '../core/app_theme.dart';
import '../core/strings.dart';
import '../screens/home_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.62;

    return Drawer(
      width: width.clamp(220, 300).toDouble(),
      backgroundColor: AppColors.drawerBody,
      shape: const RoundedRectangleBorder(),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 130,
            color: Colors.white,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 24),
            child: Text(
              S.of(context, 'news_app'),
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute<void>(
                          builder: (_) => const HomeScreen()),
                          (route) => false,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: _DrawerLabel(
                      icon: Icons.home_outlined,
                      text: S.of(context, 'go_home'),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(color: Colors.white54, thickness: 1.5),
                const SizedBox(height: 14),
                _DrawerLabel(
                  icon: Icons.format_paint_outlined,
                  text: S.of(context, 'theme'),
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: AppState.themeMode,
                  builder: (context, mode, _) {
                    return _DrawerDropdown<ThemeMode>(
                      value: mode == ThemeMode.light
                          ? ThemeMode.light
                          : ThemeMode.dark,
                      items: {
                        ThemeMode.dark: S.of(context, 'dark'),
                        ThemeMode.light: S.of(context, 'light'),
                      },
                      onChanged: (v) => AppState.themeMode.value = v,
                    );
                  },
                ),
                const SizedBox(height: 22),
                const Divider(color: Colors.white54, thickness: 1.5),
                const SizedBox(height: 14),
                _DrawerLabel(
                  icon: Icons.language,
                  text: S.of(context, 'language'),
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<Locale>(
                  valueListenable: AppState.locale,
                  builder: (context, locale, _) {
                    return _DrawerDropdown<String>(
                      value: locale.languageCode,
                      items: {
                        'en': S.of(context, 'english'),
                        'ar': S.of(context, 'arabic'),
                      },
                      onChanged: (v) => AppState.locale.value = Locale(v),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerLabel extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DrawerLabel({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _DrawerDropdown<T> extends StatelessWidget {
  final T value;
  final Map<T, String> items;
  final ValueChanged<T> onChanged;

  const _DrawerDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: Colors.white,
          iconEnabledColor: Colors.black,
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          items: items.entries
              .map((e) => DropdownMenuItem<T>(
            value: e.key,
            child: Text(e.value),
          ))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}