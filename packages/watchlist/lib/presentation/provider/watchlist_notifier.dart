import 'package:core/common/state_enum.dart';
import 'package:search/domain/entities/media.dart';
import 'package:watchlist/domain/usecases/get_watchlist_items.dart';
import 'package:watchlist/domain/usecases/get_watchlist_status.dart';
import 'package:watchlist/domain/usecases/remove_watchlist.dart';
import 'package:watchlist/domain/usecases/save_watchlist.dart';
import 'package:flutter/foundation.dart';

class WatchlistNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetWatchlistItems getWatchlistItems;
  final SaveWatchlistItem saveWatchlist;
  final RemoveWatchlistItem removeWatchlist;
  final GetWatchlistStatus getWatchListStatus;

  WatchlistNotifier({
    required this.saveWatchlist,
    required this.getWatchlistItems,
    required this.getWatchListStatus,
    required this.removeWatchlist,
  });

  var _watchlistItems = <Media>[];
  List<Media> get watchlistItems => _watchlistItems;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  bool _isAddedToWatchlist = false;
  bool get isAddedToWatchlist => _isAddedToWatchlist;

  Future<void> fetchWatchlistItems() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistItems.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (itemsData) {
        _watchlistState = RequestState.Loaded;
        _watchlistItems = itemsData;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(Media item) async {
    final result = await saveWatchlist.execute(item);

    result.fold(
      (failure) {
        _watchlistMessage = failure.message;
      },
      (successMessage) {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(item.id, item.mediaType);
  }

  Future<void> removeFromWatchlist(int id, String mediaType) async {
    final result = await removeWatchlist.execute(id, mediaType);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(id, mediaType);
  }

  Future<void> loadWatchlistStatus(int id, String mediaType) async {
    final result = await getWatchListStatus.execute(id, mediaType);
    _isAddedToWatchlist = result;
    notifyListeners();
  }
}
