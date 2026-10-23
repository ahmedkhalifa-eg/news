import '../models/models.dart';

/// The seven NewsAPI categories shown on Home (ids match NewsAPI exactly).
/// Image file names match the exported design assets in assets/images/.
const List<NewsCategory> kCategories = [
  NewsCategory(id: 'general', imageAsset: 'assets/images/earth.png'),
  NewsCategory(id: 'business', imageAsset: 'assets/images/money.png'),
  NewsCategory(id: 'sports', imageAsset: 'assets/images/messi.png'),
  NewsCategory(id: 'technology', imageAsset: 'assets/images/technology.png'),
  NewsCategory(id: 'entertainment', imageAsset: 'assets/images/popcorn.png'),
  NewsCategory(id: 'health', imageAsset: 'assets/images/helth.png'),
  NewsCategory(id: 'science', imageAsset: 'assets/images/science.png'),
];
