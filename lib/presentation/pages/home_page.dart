import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:expert_app/presentation/pages/about_page.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:tv/presentation/pages/popular_tvs_page.dart';
import 'package:search/presentation/pages/search_page.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:tv/presentation/pages/top_rated_tvs_page.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'package:watchlist/presentation/pages/watchlist_page.dart';
import 'package:movie/presentation/provider/movie_list_notifier.dart';
import 'package:core/common/state_enum.dart';
import 'package:tv/presentation/provider/tv_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MovieListNotifier>(context, listen: false)
        ..fetchNowPlayingMovies()
        ..fetchPopularMovies()
        ..fetchTopRatedMovies();
      Provider.of<TvListNotifier>(context, listen: false)
        ..fetchOnTheAirTvs()
        ..fetchPopularTvs()
        ..fetchTopRatedTvs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Jumlah tab
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/circle-g.png'),
                  backgroundColor: Colors.grey.shade900,
                ),
                accountName: Text('expert_app'),
                accountEmail: Text('expert_app@dicoding.com'),
                decoration: BoxDecoration(color: Colors.grey.shade900),
              ),
              ListTile(
                leading: Icon(Icons.movie),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.save_alt),
                title: Text('Watchlist'),
                onTap: () {
                  Navigator.pushNamed(context, WatchlistPage.ROUTE_NAME);
                },
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
                },
                leading: Icon(Icons.info_outline),
                title: Text('About'),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('expert_app'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, SearchPage.ROUTE_NAME);
              },
              icon: Icon(Icons.search),
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.amber,
            tabs: [
              Tab(icon: Icon(Icons.movie), text: 'Movies'),
              Tab(icon: Icon(Icons.tv), text: 'TV Shows'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MovieTabPage(), // Konten untuk tab Movies
            TvTabPage(), // Konten untuk tab TV Shows
          ],
        ),
      ),
    );
  }
}

class MovieTabPage extends StatelessWidget {
  const MovieTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        key: Key('movie_scroll_view'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Now Playing', style: kHeading6),
            Consumer<MovieListNotifier>(
              builder: (context, data, child) {
                final state = data.nowPlayingState;
                if (state == RequestState.Loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state == RequestState.Loaded) {
                  return MovieList(data.nowPlayingMovies);
                } else {
                  return Text('Failed to load now playing movies');
                }
              },
            ),
            _buildSubHeading(
              title: 'Popular',
              onTap: () =>
                  Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
            ),
            Consumer<MovieListNotifier>(
              builder: (context, data, child) {
                final state = data.popularMoviesState;
                if (state == RequestState.Loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state == RequestState.Loaded) {
                  return MovieList(data.popularMovies);
                } else {
                  return Text('Failed to load popular movies');
                }
              },
            ),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () =>
                  Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
            ),
            Consumer<MovieListNotifier>(
              builder: (context, data, child) {
                final state = data.topRatedMoviesState;
                if (state == RequestState.Loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state == RequestState.Loaded) {
                  return MovieList(data.topRatedMovies);
                } else {
                  return Text('Failed to load top rated movies');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Widget untuk konten tab TV Shows
class TvTabPage extends StatelessWidget {
  const TvTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        key: Key('tv_scroll_view'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Latest TV Shows', style: kHeading6),
            Consumer<TvListNotifier>(
              builder: (context, data, child) {
                final state = data.onTheAirTvsState;
                if (state == RequestState.Loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state == RequestState.Loaded) {
                  return TvList(data.onTheAirTvs);
                } else {
                  return Text('Failed to load on the latest tv shows');
                }
              },
            ),
            _buildSubHeading(
              title: 'Popular',
              onTap: () =>
                  Navigator.pushNamed(context, PopularTvsPage.ROUTE_NAME),
            ),
            Consumer<TvListNotifier>(
              builder: (context, data, child) {
                final state = data.popularTvsState;
                if (state == RequestState.Loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state == RequestState.Loaded) {
                  return TvList(data.popularTvs);
                } else {
                  return Text('Failed to load popular tv shows');
                }
              },
            ),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () =>
                  Navigator.pushNamed(context, TopRatedTvsPage.ROUTE_NAME),
            ),
            Consumer<TvListNotifier>(
              builder: (context, data, child) {
                final state = data.topRatedTvsState;
                if (state == RequestState.Loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state == RequestState.Loaded) {
                  return TvList(data.topRatedTvs);
                } else {
                  return Text('Failed to load top rated tv shows');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

Row _buildSubHeading({required String title, required Function() onTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: kHeading6),
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
          ),
        ),
      ),
    ],
  );
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList(this.movies, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${movie.posterPath}',
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}

class TvList extends StatelessWidget {
  final List<Tv> tvs;

  const TvList(this.tvs, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvs[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${tv.posterPath}',
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvs.length,
      ),
    );
  }
}
