import 'package:core/common/state_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_on_the_air_tvs.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';

part 'tv_list_event.dart';
part 'tv_list_state.dart';

class TvListBloc extends Bloc<TvListEvent, TvListState> {
  final GetOnTheAirTvs _getOnTheAirTvs;
  final GetPopularTvs _getPopularTvs;
  final GetTopRatedTvs _getTopRatedTvs;

  TvListBloc(this._getOnTheAirTvs, this._getPopularTvs, this._getTopRatedTvs)
    : super(const TvListState()) {
    on<FetchOnTheAirTvs>((event, emit) async {
      emit(state.copyWith(onTheAirState: RequestState.loading));
      final result = await _getOnTheAirTvs.execute();
      result.fold(
        (failure) => emit(
          state.copyWith(
            onTheAirState: RequestState.error,
            message: failure.message,
          ),
        ),
        (data) => emit(
          state.copyWith(onTheAirState: RequestState.loaded, onTheAirTvs: data),
        ),
      );
    });

    on<FetchPopularTvs>((event, emit) async {
      emit(state.copyWith(popularTvsState: RequestState.loading));
      final result = await _getPopularTvs.execute();
      result.fold(
        (failure) => emit(
          state.copyWith(
            popularTvsState: RequestState.error,
            message: failure.message,
          ),
        ),
        (data) => emit(
          state.copyWith(
            popularTvsState: RequestState.loaded,
            popularTvs: data,
          ),
        ),
      );
    });

    on<FetchTopRatedTvs>((event, emit) async {
      emit(state.copyWith(topRatedTvsState: RequestState.loading));
      final result = await _getTopRatedTvs.execute();
      result.fold(
        (failure) => emit(
          state.copyWith(
            topRatedTvsState: RequestState.error,
            message: failure.message,
          ),
        ),
        (data) => emit(
          state.copyWith(
            topRatedTvsState: RequestState.loaded,
            topRatedTvs: data,
          ),
        ),
      );
    });
  }
}
