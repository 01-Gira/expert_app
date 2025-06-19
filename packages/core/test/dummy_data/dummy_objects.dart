import 'package:watchlist/data/models/watchlist_table.dart';
import 'package:search/domain/entities/media.dart';

// === WATCHLIST & MEDIA DUMMIES ===

final testWatchlistItem = Media(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
  mediaType: 'movie',
);

final testWatchlistItems = [testWatchlistItem];

final testWatchlistTable = WatchlistTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
  mediaType: 'movie',
);

final testWatchlistMap = {
  'id': 1,
  'title': 'title',
  'posterPath': 'posterPath',
  'overview': 'overview',
  'mediaType': 'movie',
};
