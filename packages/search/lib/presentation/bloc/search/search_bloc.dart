import 'package:search/domain/entities/media.dart';
import 'package:search/domain/usecases/search_multi.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMulti _searchMulti;

  SearchBloc(this._searchMulti) : super(SearchEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchLoading());
      final result = await _searchMulti.execute(query);

      result.fold(
        (failure) {
          emit(SearchError(failure.message));
        },
        (data) {
          emit(SearchLoaded(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
