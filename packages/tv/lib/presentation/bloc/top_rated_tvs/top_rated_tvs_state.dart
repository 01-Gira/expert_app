part of 'top_rated_tvs_bloc.dart';

abstract class TopRatedTvsState extends Equatable {
  const TopRatedTvsState();

  @override
  List<Object> get props => [];
}

class TopRatedTvsEmpty extends TopRatedTvsState {}

class TopRatedTvsLoading extends TopRatedTvsState {}

class TopRatedTvsLoaded extends TopRatedTvsState {
  final List<Tv> tvs;

  const TopRatedTvsLoaded(this.tvs);

  @override
  List<Object> get props => [tvs];
}

class TopRatedTvsError extends TopRatedTvsState {
  final String message;

  const TopRatedTvsError(this.message);

  @override
  List<Object> get props => [message];
}
