import 'package:flutter/material.dart';

/// Tiny localisation helper (English / Arabic).
class S {
  S._();

  static const Map<String, String> _en = {
    'home': 'Home',
    'greeting': 'Good Morning\nHere is Some News For You',
    'view_all': 'View All',
    'news_app': 'News App',
    'go_home': 'Go To Home',
    'theme': 'Theme',
    'language': 'Language',
    'dark': 'Dark',
    'light': 'Light',
    'english': 'English',
    'arabic': 'العربية',
    'search': 'Search',
    'by': 'By',
    'view_full_article': 'View Full Article',
    'no_results': 'No results found',
    'try_again': 'Try again',
    'type_to_search': 'Type to search the news',
    'min_ago': 'minutes ago',
    'hour_ago': 'hours ago',
    'day_ago': 'days ago',
    'just_now': 'just now',
    'supervised_by': 'Supervised by Mohamed Nabil',
    'general': 'General',
    'business': 'Business',
    'sports': 'Sports',
    'technology': 'Technology',
    'entertainment': 'Entertainment',
    'health': 'Health',
    'science': 'Science',
  };

  static const Map<String, String> _ar = {
    'home': 'الرئيسية',
    'greeting': 'صباح الخير\nإليك بعض الأخبار',
    'view_all': 'عرض الكل',
    'news_app': 'تطبيق الأخبار',
    'go_home': 'الذهاب للرئيسية',
    'theme': 'المظهر',
    'language': 'اللغة',
    'dark': 'داكن',
    'light': 'فاتح',
    'english': 'English',
    'arabic': 'العربية',
    'search': 'بحث',
    'by': 'بواسطة',
    'view_full_article': 'عرض المقال كاملاً',
    'no_results': 'لا توجد نتائج',
    'try_again': 'إعادة المحاولة',
    'type_to_search': 'اكتب للبحث في الأخبار',
    'min_ago': 'دقيقة مضت',
    'hour_ago': 'ساعة مضت',
    'day_ago': 'يوم مضى',
    'just_now': 'الآن',
    'supervised_by': 'بإشراف محمد نبيل',
    'general': 'عام',
    'business': 'أعمال',
    'sports': 'رياضة',
    'technology': 'تكنولوجيا',
    'entertainment': 'ترفيه',
    'health': 'صحة',
    'science': 'علوم',
  };

  static String of(BuildContext context, String key) {
    final code = Localizations.localeOf(context).languageCode;
    final map = code == 'ar' ? _ar : _en;
    return map[key] ?? key;
  }

  static String timeAgo(BuildContext context, DateTime? time) {
    if (time == null) return '';
    final diff = DateTime.now().toUtc().difference(time.toUtc());
    if (diff.inMinutes < 1) return of(context, 'just_now');
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} ${of(context, 'min_ago')}';
    }
    if (diff.inHours < 24) return '${diff.inHours} ${of(context, 'hour_ago')}';
    return '${diff.inDays} ${of(context, 'day_ago')}';
  }
}
