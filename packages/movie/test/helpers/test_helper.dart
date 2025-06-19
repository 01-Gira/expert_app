import 'package:movie/data/datasources/movie_remote_data_source.dart';
import 'package:movie/domain/repositories/movie_repository.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:watchlist/domain/usecases/get_watchlist_items.dart';
import 'package:watchlist/domain/usecases/get_watchlist_status.dart';
import 'package:watchlist/domain/usecases/remove_watchlist.dart';
import 'package:watchlist/domain/usecases/save_watchlist.dart';
import 'package:movie/presentation/provider/movie_detail_notifier.dart';
import 'package:movie/presentation/provider/popular_movies_notifier.dart';
import 'package:movie/presentation/provider/top_rated_movies_notifier.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:watchlist/presentation/provider/watchlist_notifier.dart';

@GenerateMocks(
  [
    MovieRepository,
    MovieRemoteDataSource,
    GetMovieDetail,
    GetMovieRecommendations,
    GetNowPlayingMovies,
    GetPopularMovies,
    GetTopRatedMovies,
    MovieDetailNotifier,
    PopularMoviesNotifier,
    TopRatedMoviesNotifier,
    WatchlistNotifier,
    GetWatchlistItems,
    GetWatchlistStatus,
    SaveWatchlistItem,
    RemoveWatchlistItem,
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
