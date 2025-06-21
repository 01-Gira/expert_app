import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:expert_app/presentation/pages/about_page.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:tv/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:tv/presentation/pages/popular_tvs_page.dart';
import 'package:search/presentation/pages/search_page.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:tv/presentation/pages/top_rated_tvs_page.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'package:watchlist/presentation/pages/watchlist_page.dart';
import 'package:movie/presentation/provider/movie_list_notifier.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        Provider.of<MovieListNotifier>(context, listen: false)
          ..fetchNowPlayingMovies()
          ..fetchPopularMovies()
          ..fetchTopRatedMovies();
        context.read<TvListBloc>().add(FetchOnTheAirTvs());
        context.read<TvListBloc>().add(FetchPopularTvs());
        context.read<TvListBloc>().add(FetchTopRatedTvs());
      }
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
                  Navigator.pushNamed(context, WatchlistPage.routeName);
                },
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, AboutPage.routeName);
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
                Navigator.pushNamed(context, SearchPage.routeName);
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
                if (state == RequestState.loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state == RequestState.loaded) {
                  return MovieList(data.nowPlayingMovies);
                } else {
                  return Text('Failed to load now playing movies');
                }
              },
            ),
            _buildSubHeading(
              title: 'Popular',
              onTap: () =>
                  Navigator.pushNamed(context, PopularMoviesPage.routeName),
            ),
            Consumer<MovieListNotifier>(
              builder: (context, data, child) {
                final state = data.popularMoviesState;
                if (state == RequestState.loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state == RequestState.loaded) {
                  return MovieList(data.popularMovies);
                } else {
                  return Text('Failed to load popular movies');
                }
              },
            ),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () =>
                  Navigator.pushNamed(context, TopRatedMoviesPage.routeName),
            ),
            Consumer<MovieListNotifier>(
              builder: (context, data, child) {
                final state = data.topRatedMoviesState;
                if (state == RequestState.loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state == RequestState.loaded) {
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
            Text('On The Air', style: kHeading6),
            BlocBuilder<TvListBloc, TvListState>(
              builder: (context, state) {
                if (state.onTheAirState == RequestState.loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state.onTheAirState == RequestState.loaded) {
                  return TvList(state.onTheAirTvs);
                } else if (state.onTheAirState == RequestState.error) {
                  return Text(state.message);
                } else {
                  return Text('Failed to load data');
                }
              },
            ),
            _buildSubHeading(
              title: 'Popular',
              onTap: () =>
                  Navigator.pushNamed(context, PopularTvsPage.routeName),
            ),
            BlocBuilder<TvListBloc, TvListState>(
              builder: (context, state) {
                if (state.popularTvsState == RequestState.loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state.popularTvsState == RequestState.loaded) {
                  return TvList(state.popularTvs);
                } else {
                  return Text(state.message);
                }
              },
            ),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () =>
                  Navigator.pushNamed(context, TopRatedTvsPage.routeName),
            ),
            BlocBuilder<TvListBloc, TvListState>(
              builder: (context, state) {
                if (state.topRatedTvsState == RequestState.loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state.topRatedTvsState == RequestState.loaded) {
                  return TvList(state.topRatedTvs);
                } else {
                  return Text(state.message);
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
                  MovieDetailPage.routeName,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child:
                    (movie.posterPath != null && movie.posterPath!.isNotEmpty)
                    ? CachedNetworkImage(
                        imageUrl: '$baseImageUrl${movie.posterPath}',
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )
                    : Container(
                        color: Colors.grey[800],
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                          ),
                        ),
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
                  TvDetailPage.routeName,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: (tv.posterPath != null)
                    ? CachedNetworkImage(
                        imageUrl: '$baseImageUrl${tv.posterPath}',
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )
                    : Container(
                        color: Colors.grey[800],
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                          ),
                        ),
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
