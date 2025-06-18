import 'package:expert_app/common/constants.dart';
import 'package:expert_app/common/utils.dart';
import 'package:expert_app/presentation/pages/about_page.dart';
import 'package:expert_app/presentation/pages/movie_detail_page.dart';
import 'package:expert_app/presentation/pages/home_page.dart';
import 'package:expert_app/presentation/pages/popular_movies_page.dart';
import 'package:expert_app/presentation/pages/popular_tvs_page.dart';
import 'package:expert_app/presentation/pages/search_page.dart';
import 'package:expert_app/presentation/pages/top_rated_movies_page.dart';
import 'package:expert_app/presentation/pages/top_rated_tvs_page.dart';
import 'package:expert_app/presentation/pages/tv_detail_page.dart';
import 'package:expert_app/presentation/pages/watchlist_page.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expert_app/injection.dart' as di;

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.locator<MovieListNotifier>()),
        ChangeNotifierProvider(create: (_) => di.locator<TvListNotifier>()),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(create: (_) => di.locator<TvDetailNotifier>()),
        ChangeNotifierProvider(create: (_) => di.locator<SearchNotifier>()),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedTvsNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularMoviesNotifier>(),
        ),
        ChangeNotifierProvider(create: (_) => di.locator<PopularTvsNotifier>()),
        ChangeNotifierProvider(create: (_) => di.locator<WatchlistNotifier>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomePage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case PopularTvsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTvsPage());
            case TopRatedTvsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTvsPage());
            case TvDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case WatchlistPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return Scaffold(
                    body: Center(child: Text('Page not found :(')),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
