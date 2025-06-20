import 'package:core/data/datasources/db/database_helper.dart';
import 'package:movie/data/datasources/movie_remote_data_source.dart';
import 'package:search/data/datasources/search_remote_data_source.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:tv/presentation/bloc/popular_tvs/popular_tvs_bloc.dart';
import 'package:tv/presentation/bloc/top_rated_tvs/top_rated_tvs_bloc.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:watchlist/data/datasources/watchlist_local_data_source.dart';
import 'package:movie/data/repositories/movie_repository_impl.dart';
import 'package:search/data/repositories/search_repository_impl.dart';
import 'package:tv/data/repositories/tv_repository_impl.dart';
import 'package:watchlist/data/repositories/watchlist_repository_impl.dart';
import 'package:movie/domain/repositories/movie_repository.dart';
import 'package:search/domain/repositories/search_repository.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:watchlist/domain/repositories/watchlist_repository.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:tv/domain/usecases/get_on_the_air_tvs.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:watchlist/domain/usecases/get_watchlist_items.dart';
import 'package:watchlist/domain/usecases/get_watchlist_status.dart';
import 'package:watchlist/domain/usecases/remove_watchlist.dart';
import 'package:watchlist/domain/usecases/save_watchlist.dart';
import 'package:search/domain/usecases/search_multi.dart';
import 'package:search/presentation/bloc/search/search_bloc.dart';
import 'package:movie/presentation/provider/movie_detail_notifier.dart';
import 'package:movie/presentation/provider/movie_list_notifier.dart';
import 'package:movie/presentation/provider/popular_movies_notifier.dart';
import 'package:movie/presentation/provider/top_rated_movies_notifier.dart';
import 'package:watchlist/presentation/provider/watchlist_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:core/network/ssl_pinning.dart';

final locator = GetIt.instance;

Future<void> init() async {
  await SSLPinning.init();

  locator.registerLazySingleton<http.Client>(() => SSLPinning.client);

  // Movie
  // provider
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
    ),
  );

  locator.registerFactory(() => PopularMoviesNotifier(locator()));
  locator.registerFactory(
    () => TopRatedMoviesNotifier(getTopRatedMovies: locator()),
  );

  // Tv
  locator.registerFactory(() => TvListBloc(locator(), locator(), locator()));
  locator.registerFactory(
    () => TvDetailBloc(
      getTvDetail: locator(),
      getTvRecommendations: locator(),
      getWatchlistStatus: locator(),
      saveWatchlistItem: locator(),
      removeWatchlistItem: locator(),
    ),
  );

  locator.registerFactory(() => PopularTvsBloc(locator()));
  locator.registerFactory(() => TopRatedTvsBloc(locator()));

  // Watchlist
  locator.registerFactory(
    () => WatchlistNotifier(
      saveWatchlist: locator(),
      getWatchlistItems: locator(),
      getWatchListStatus: locator(),
      removeWatchlist: locator(),
    ),
  );

  locator.registerFactory(() => SearchBloc(locator()));

  // Movie
  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));

  // Tv
  locator.registerLazySingleton(() => GetOnTheAirTvs(locator()));
  locator.registerLazySingleton(() => GetPopularTvs(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvs(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));

  // Watchlist
  locator.registerLazySingleton(() => GetWatchlistStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlistItem(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistItem(locator()));
  locator.registerLazySingleton(() => GetWatchlistItems(locator()));

  locator.registerLazySingleton(() => SearchMulti(locator()));
  // Movie
  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(remoteDataSource: locator()),
  );
  // Tv
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(remoteDataSource: locator()),
  );

  // Watchlist
  locator.registerLazySingleton<WatchlistRepository>(
    () => WatchlistRepositoryImpl(localDataSource: locator()),
  );

  locator.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: locator()),
  );

  // Movie
  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: locator()),
  );

  // Tv
  locator.registerLazySingleton<TvRemoteDataSource>(
    () => TvRemoteDataSourceImpl(client: locator()),
  );

  // Watchlist
  locator.registerLazySingleton<WatchlistLocalDataSource>(
    () => WatchlistLocalDataSourceImpl(databaseHelper: locator()),
  );

  locator.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(client: locator()),
  );

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
}
