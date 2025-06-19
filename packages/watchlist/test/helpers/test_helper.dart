import 'package:core/data/datasources/db/database_helper.dart';
import 'package:watchlist/data/datasources/watchlist_local_data_source.dart';
import 'package:watchlist/domain/repositories/watchlist_repository.dart';
import 'package:watchlist/domain/usecases/get_watchlist_items.dart';
import 'package:watchlist/domain/usecases/get_watchlist_status.dart';
import 'package:watchlist/domain/usecases/remove_watchlist.dart';
import 'package:watchlist/domain/usecases/save_watchlist.dart';
import 'package:watchlist/presentation/provider/watchlist_notifier.dart';

import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks(
  [
    DatabaseHelper,
    WatchlistRepository,
    WatchlistLocalDataSource,
    WatchlistNotifier,
    GetWatchlistItems,
    GetWatchlistStatus,
    SaveWatchlistItem,
    RemoveWatchlistItem,
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
