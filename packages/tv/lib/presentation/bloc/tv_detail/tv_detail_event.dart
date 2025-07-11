part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTvDetail extends TvDetailEvent {
  final int id;
  const FetchTvDetail(this.id);

  @override
  List<Object> get props => [id];
}

class AddToWatchlist extends TvDetailEvent {
  final TvDetail tv;
  const AddToWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}

class RemoveFromWatchlist extends TvDetailEvent {
  final TvDetail tv;
  const RemoveFromWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}
