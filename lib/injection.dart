import 'package:expert_app/data/datasources/db/database_helper.dart';
import 'package:expert_app/data/datasources/movie_remote_data_source.dart';
import 'package:expert_app/data/datasources/search_remote_data_source.dart';
import 'package:expert_app/data/datasources/tv_remote_data_source.dart';
import 'package:expert_app/data/datasources/watchlist_local_data_source.dart';
import 'package:expert_app/data/repositories/movie_repository_impl.dart';
import 'package:expert_app/data/repositories/search_repository_impl.dart';
import 'package:expert_app/data/repositories/tv_repository_impl.dart';
import 'package:expert_app/data/repositories/watchlist_repository_impl.dart';
import 'package:expert_app/domain/repositories/movie_repository.dart';
import 'package:expert_app/domain/repositories/search_repository.dart';
import 'package:expert_app/domain/repositories/tv_repository.dart';
import 'package:expert_app/domain/repositories/watchlist_repository.dart';
import 'package:expert_app/domain/usecases/get_movie_detail.dart';
import 'package:expert_app/domain/usecases/get_movie_recommendations.dart';
import 'package:expert_app/domain/usecases/get_now_playing_movies.dart';
import 'package:expert_app/domain/usecases/get_on_the_air_tvs.dart';
import 'package:expert_app/domain/usecases/get_popular_movies.dart';
import 'package:expert_app/domain/usecases/get_popular_tvs.dart';
import 'package:expert_app/domain/usecases/get_top_rated_movies.dart';
import 'package:expert_app/domain/usecases/get_top_rated_tvs.dart';
import 'package:expert_app/domain/usecases/get_tv_detail.dart';
import 'package:expert_app/domain/usecases/get_tv_recommendations.dart';
import 'package:expert_app/domain/usecases/get_watchlist_items.dart';
import 'package:expert_app/domain/usecases/get_watchlist_status.dart';
import 'package:expert_app/domain/usecases/remove_watchlist.dart';
import 'package:expert_app/domain/usecases/save_watchlist.dart';
import 'package:expert_app/domain/usecases/search_multi.dart';
import 'package:expert_app/presentation/provider/movie_detail_notifier.dart';
import 'package:expert_app/presentation/provider/movie_list_notifier.dart';
import 'package:expert_app/presentation/provider/popular_movies_notifier.dart';
import 'package:expert_app/presentation/provider/popular_tvs_notifier.dart';
import 'package:expert_app/presentation/provider/search_notifier.dart';
import 'package:expert_app/presentation/provider/top_rated_movies_notifier.dart';
import 'package:expert_app/presentation/provider/top_rated_tvs_notifier.dart';
import 'package:expert_app/presentation/provider/tv_detail_notifier.dart';
import 'package:expert_app/presentation/provider/tv_list_notifier.dart';
import 'package:expert_app/presentation/provider/watchlist_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
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
  locator.registerFactory(
    () => TvListNotifier(
      getOnTheAirTvs: locator(),
      getPopularTvs: locator(),
      getTopRatedTvs: locator(),
    ),
  );
  locator.registerFactory(
    () => TvDetailNotifier(
      getTvDetail: locator(),
      getTvRecommendations: locator(),
    ),
  );
  locator.registerFactory(() => PopularTvsNotifier(locator()));
  locator.registerFactory(() => TopRatedTvsNotifier(getTopRatedTvs: locator()));

  // Watchlist
  locator.registerFactory(
    () => WatchlistNotifier(
      saveWatchlist: locator(),
      getWatchlistItems: locator(),
      getWatchListStatus: locator(),
      removeWatchlist: locator(),
    ),
  );

  locator.registerFactory(() => SearchNotifier(searchMulti: locator()));

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
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      // localDataSource: locator(),
    ),
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

  // external
  locator.registerLazySingleton(() => http.Client());
}
