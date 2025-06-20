part of 'popular_tvs_bloc.dart';

abstract class PopularTvsEvent extends Equatable {
  const PopularTvsEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularTvs extends PopularTvsEvent {}
