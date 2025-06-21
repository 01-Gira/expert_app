import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:movie/domain/entities/genre.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/presentation/provider/movie_detail_notifier.dart';
import 'package:core/common/state_enum.dart';
import 'package:watchlist/presentation/provider/watchlist_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class MovieDetailPage extends StatefulWidget {
  static const routeName = '/movie-detail';

  final int id;
  const MovieDetailPage({super.key, required this.id});

  @override
  MovieDetailPageState createState() => MovieDetailPageState();
}

class MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        Provider.of<MovieDetailNotifier>(
          context,
          listen: false,
        ).fetchMovieDetail(widget.id);
        Provider.of<WatchlistNotifier>(
          context,
          listen: false,
        ).loadWatchlistStatus(widget.id, 'movie');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MovieDetailNotifier>(
        builder: (context, movieDetailProvider, child) {
          if (movieDetailProvider.movieState == RequestState.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (movieDetailProvider.movieState == RequestState.loaded) {
            final movie = movieDetailProvider.movie;
            return Consumer<WatchlistNotifier>(
              builder: (context, watchlistProvider, child) {
                final isAddedToWatchlist = watchlistProvider.isAddedToWatchlist;
                return SafeArea(
                  child: DetailContent(
                    movie,
                    movieDetailProvider.movieRecommendations,
                    isAddedToWatchlist,
                  ),
                );
              },
            );
          } else {
            return Text(movieDetailProvider.message);
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;

  const DetailContent(
    this.movie,
    this.recommendations,
    this.isAddedWatchlist, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        (movie.posterPath != '')
            ? CachedNetworkImage(
                imageUrl: '$baseImageUrl${movie.posterPath}',
                width: screenWidth,

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
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(movie.title, style: kHeading5),
                            FilledButton(
                              onPressed: () async {
                                final watchlistNotifier =
                                    Provider.of<WatchlistNotifier>(
                                      context,
                                      listen: false,
                                    );
                                final scaffoldMessenger = ScaffoldMessenger.of(
                                  context,
                                );

                                if (!isAddedWatchlist) {
                                  final mediaItem = movie.toMedia();
                                  await watchlistNotifier.addWatchlist(
                                    mediaItem,
                                  );
                                } else {
                                  await watchlistNotifier.removeFromWatchlist(
                                    movie.id,
                                    'movie',
                                  );
                                }

                                final message =
                                    watchlistNotifier.watchlistMessage;

                                // DIUBAH: Gunakan referensi messenger dan cek 'mounted'
                                if (context.mounted) {
                                  if (message ==
                                          WatchlistNotifier
                                              .watchlistAddSuccessMessage ||
                                      message ==
                                          WatchlistNotifier
                                              .watchlistRemoveSuccessMessage) {
                                    scaffoldMessenger.showSnackBar(
                                      SnackBar(content: Text(message)),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(message),
                                        );
                                      },
                                    );
                                  }
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(_showGenres(movie.genres)),
                            Text(_showDuration(movie.runtime)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) =>
                                      Icon(Icons.star, color: kMikadoYellow),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}'),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text('Overview', style: kHeading6),
                            Text(movie.overview),
                            SizedBox(height: 16),
                            Text('Recommendations', style: kHeading6),
                            Consumer<MovieDetailNotifier>(
                              builder: (context, data, child) {
                                if (data.recommendationState ==
                                    RequestState.loading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (data.recommendationState ==
                                    RequestState.error) {
                                  return Text(data.message);
                                } else if (data.recommendationState ==
                                    RequestState.loaded) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final movie = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                MovieDetailPage.routeName,
                                                arguments: movie.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child:
                                                  (movie.posterPath != null &&
                                                      movie
                                                          .posterPath!
                                                          .isNotEmpty)
                                                  ? CachedNetworkImage(
                                                      imageUrl:
                                                          '$baseImageUrl${movie.posterPath}',
                                                      placeholder:
                                                          (
                                                            context,
                                                            url,
                                                          ) => Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                      errorWidget:
                                                          (
                                                            context,
                                                            url,
                                                            error,
                                                          ) =>
                                                              Icon(Icons.error),
                                                    )
                                                  : Container(
                                                      color: Colors.grey[800],
                                                      child: Center(
                                                        child: Icon(
                                                          Icons
                                                              .image_not_supported,
                                                          color:
                                                              Colors.grey[400],
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    return genres.map((e) => e.name).toList().join(',');
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
