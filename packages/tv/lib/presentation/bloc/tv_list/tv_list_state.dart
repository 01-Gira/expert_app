part of 'tv_list_bloc.dart';

class TvListState extends Equatable {
  final RequestState onTheAirState;
  final List<Tv> onTheAirTvs;
  final RequestState popularTvsState;
  final List<Tv> popularTvs;
  final RequestState topRatedTvsState;
  final List<Tv> topRatedTvs;
  final String message;

  const TvListState({
    this.onTheAirState = RequestState.empty,
    this.onTheAirTvs = const [],
    this.popularTvsState = RequestState.empty,
    this.popularTvs = const [],
    this.topRatedTvsState = RequestState.empty,
    this.topRatedTvs = const [],
    this.message = '',
  });

  TvListState copyWith({
    RequestState? onTheAirState,
    List<Tv>? onTheAirTvs,
    RequestState? popularTvsState,
    List<Tv>? popularTvs,
    RequestState? topRatedTvsState,
    List<Tv>? topRatedTvs,
    String? message,
  }) {
    return TvListState(
      onTheAirState: onTheAirState ?? this.onTheAirState,
      onTheAirTvs: onTheAirTvs ?? this.onTheAirTvs,
      popularTvsState: popularTvsState ?? this.popularTvsState,
      popularTvs: popularTvs ?? this.popularTvs,
      topRatedTvsState: topRatedTvsState ?? this.topRatedTvsState,
      topRatedTvs: topRatedTvs ?? this.topRatedTvs,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    onTheAirState,
    onTheAirTvs,
    popularTvsState,
    popularTvs,
    topRatedTvsState,
    topRatedTvs,
    message,
  ];
}
