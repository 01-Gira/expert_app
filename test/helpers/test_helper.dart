import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/watchlist_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/datasources/search_remote_data_source.dart';
import 'package:ditonton/domain/repositories/watchlist_repository.dart';
import 'package:ditonton/domain/repositories/search_repository.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tvs.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_tvs.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvs.dart';
import 'package:ditonton/domain/usecases/get_watchlist_items.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/popular_tvs_notifier.dart';
import 'package:ditonton/presentation/provider/search_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_tvs_notifier.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_notifier.dart';

import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  TvRepository,
  TvRemoteDataSource,
  WatchlistRepository,
  WatchlistLocalDataSource,
  SearchRepository,
  SearchRemoteDataSource,
  DatabaseHelper,
  SearchNotifier,
  GetMovieDetail,
  GetMovieRecommendations,
  GetNowPlayingMovies,
  GetPopularMovies,
  GetTopRatedMovies,
  GetPopularTvs,
  PopularTvsNotifier,
  MovieDetailNotifier,
  WatchlistNotifier,
  PopularMoviesNotifier,
  TopRatedMoviesNotifier,
  TopRatedTvsNotifier,
  TvDetailNotifier,
  GetTopRatedTvs,
  GetOnTheAirTvs,
  GetWatchlistItems,
  GetWatchlistStatus,
  SaveWatchlistItem,
  RemoveWatchlistItem,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
