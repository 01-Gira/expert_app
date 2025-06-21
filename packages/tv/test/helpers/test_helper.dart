import 'package:flutter/material.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:tv/domain/usecases/get_on_the_air_tvs.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/presentation/bloc/popular_tvs/popular_tvs_bloc.dart';
import 'package:tv/presentation/bloc/top_rated_tvs/top_rated_tvs_bloc.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:watchlist/domain/repositories/watchlist_repository.dart'; // Jika belum ada
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:watchlist/domain/usecases/get_watchlist_status.dart';
import 'package:watchlist/domain/usecases/remove_watchlist.dart';
import 'package:watchlist/domain/usecases/save_watchlist.dart';

@GenerateMocks(
  [
    TvRepository,
    TvRemoteDataSource,
    GetPopularTvs,
    GetTopRatedTvs,
    GetOnTheAirTvs,
    GetTvDetail,
    GetTvRecommendations,
    GetWatchlistStatus,
    SaveWatchlistItem,
    RemoveWatchlistItem,
    TvDetailBloc,
    TvListBloc,
    NavigatorObserver,
    TopRatedTvsBloc,
    PopularTvsBloc,
    WatchlistRepository,
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
