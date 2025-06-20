import 'package:core/common/state_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:watchlist/domain/usecases/get_watchlist_status.dart';
import 'package:watchlist/domain/usecases/remove_watchlist.dart';
import 'package:watchlist/domain/usecases/save_watchlist.dart';
part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchlistStatus getWatchlistStatus;
  final SaveWatchlistItem saveWatchlistItem;
  final RemoveWatchlistItem removeWatchlistItem;

  TvDetailBloc({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchlistStatus,
    required this.saveWatchlistItem,
    required this.removeWatchlistItem,
  }) : super(const TvDetailState()) {
    on<FetchTvDetail>(_onFetchTvDetail);
    on<AddToWatchlist>(_onAddToWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
  }

  Future<void> _onFetchTvDetail(
    FetchTvDetail event,
    Emitter<TvDetailState> emit,
  ) async {
    emit(state.copyWith(tvState: RequestState.loading));
    final detailResult = await getTvDetail.execute(event.id);
    final recommendationResult = await getTvRecommendations.execute(event.id);
    final watchlistStatus = await getWatchlistStatus.execute(event.id, 'tv');

    detailResult.fold(
      (failure) => emit(
        state.copyWith(tvState: RequestState.error, message: failure.message),
      ),
      (detailData) {
        emit(
          state.copyWith(
            recommendationState: RequestState.loading,
            tv: detailData,
            isAddedToWatchlist: watchlistStatus,
          ),
        );
        recommendationResult.fold(
          (failure) => emit(
            state.copyWith(
              recommendationState: RequestState.error,
              message: failure.message,
            ),
          ),
          (recommendationData) => emit(
            state.copyWith(
              tvState: RequestState.loaded,
              recommendationState: RequestState.loaded,
              tvRecommendations: recommendationData,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onAddToWatchlist(
    AddToWatchlist event,
    Emitter<TvDetailState> emit,
  ) async {
    final result = await saveWatchlistItem.execute(event.tv.toMedia());
    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
      (successMessage) =>
          emit(state.copyWith(watchlistMessage: successMessage)),
    );
    final status = await getWatchlistStatus.execute(event.tv.id, 'tv');
    emit(state.copyWith(isAddedToWatchlist: status));
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveFromWatchlist event,
    Emitter<TvDetailState> emit,
  ) async {
    final result = await removeWatchlistItem.execute(event.tv.id, 'tv');
    result.fold(
      (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
      (successMessage) =>
          emit(state.copyWith(watchlistMessage: successMessage)),
    );
    final status = await getWatchlistStatus.execute(event.tv.id, 'tv');
    emit(state.copyWith(isAddedToWatchlist: status));
  }
}
