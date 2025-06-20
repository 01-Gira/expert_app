import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';

part 'popular_tvs_event.dart';
part 'popular_tvs_state.dart';

class PopularTvsBloc extends Bloc<PopularTvsEvent, PopularTvsState> {
  final GetPopularTvs _getPopularTvs;

  PopularTvsBloc(this._getPopularTvs) : super(PopularTvsEmpty()) {
    on<FetchPopularTvs>((event, emit) async {
      emit(PopularTvsLoading());
      final result = await _getPopularTvs.execute();

      result.fold(
        (failure) {
          emit(PopularTvsError(failure.message));
        },
        (data) {
          emit(PopularTvsLoaded(data));
        },
      );
    });
  }
}
