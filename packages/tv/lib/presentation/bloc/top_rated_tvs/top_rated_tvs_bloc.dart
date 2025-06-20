import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';

part 'top_rated_tvs_event.dart';
part 'top_rated_tvs_state.dart';

class TopRatedTvsBloc extends Bloc<TopRatedTvsEvent, TopRatedTvsState> {
  final GetTopRatedTvs _getTopRatedTvs;

  TopRatedTvsBloc(this._getTopRatedTvs) : super(TopRatedTvsEmpty()) {
    on<FetchTopRatedTvs>((event, emit) async {
      emit(TopRatedTvsLoading());
      final result = await _getTopRatedTvs.execute();

      result.fold(
        (failure) {
          emit(TopRatedTvsError(failure.message));
        },
        (data) {
          emit(TopRatedTvsLoaded(data));
        },
      );
    });
  }
}
