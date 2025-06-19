import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:tv/domain/usecases/get_on_the_air_tvs.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/presentation/provider/popular_tvs_notifier.dart';
import 'package:tv/presentation/provider/top_rated_tvs_notifier.dart';
import 'package:tv/presentation/provider/tv_detail_notifier.dart';

import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:watchlist/presentation/provider/watchlist_notifier.dart';

@GenerateMocks(
  [
    TvRepository,
    TvRemoteDataSource,
    GetPopularTvs,
    PopularTvsNotifier,
    TopRatedTvsNotifier,
    TvDetailNotifier,
    GetTopRatedTvs,
    GetOnTheAirTvs,
    WatchlistNotifier,
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
