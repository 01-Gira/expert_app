import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/media.dart';
import 'package:ditonton/domain/usecases/search_multi.dart';
import 'package:flutter/foundation.dart';

class SearchNotifier extends ChangeNotifier {
  final SearchMulti searchMulti;

  SearchNotifier({required this.searchMulti});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Media> _searchResult = [];
  List<Media> get searchResult => _searchResult;

  String _message = '';
  String get message => _message;

  Future<void> fetchMultiSearch(String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await searchMulti.execute(query);
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _searchResult = data;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
