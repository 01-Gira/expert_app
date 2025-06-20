part of 'tv_detail_bloc.dart';

class TvDetailState extends Equatable {
  final RequestState tvState;
  final TvDetail? tv;
  final RequestState recommendationState;
  final List<Tv> tvRecommendations;
  final bool isAddedToWatchlist;
  final String message;
  final String watchlistMessage;

  const TvDetailState({
    this.tvState = RequestState.empty,
    this.tv,
    this.recommendationState = RequestState.empty,
    this.tvRecommendations = const [],
    this.isAddedToWatchlist = false,
    this.message = '',
    this.watchlistMessage = '',
  });

  TvDetailState copyWith({
    RequestState? tvState,
    TvDetail? tv,
    RequestState? recommendationState,
    List<Tv>? tvRecommendations,
    bool? isAddedToWatchlist,
    String? message,
    String? watchlistMessage,
  }) {
    return TvDetailState(
      tvState: tvState ?? this.tvState,
      tv: tv ?? this.tv,
      recommendationState: recommendationState ?? this.recommendationState,
      tvRecommendations: tvRecommendations ?? this.tvRecommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    tvState,
    tv,
    recommendationState,
    tvRecommendations,
    isAddedToWatchlist,
    message,
    watchlistMessage,
  ];
}
