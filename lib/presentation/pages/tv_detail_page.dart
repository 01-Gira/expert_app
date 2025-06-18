import 'package:cached_network_image/cached_network_image.dart';
import 'package:expert_app/common/constants.dart';
import 'package:expert_app/domain/entities/genre.dart';
import 'package:expert_app/domain/entities/tv.dart';
import 'package:expert_app/domain/entities/tv_detail.dart';
import 'package:expert_app/presentation/provider/tv_detail_notifier.dart';
import 'package:expert_app/common/state_enum.dart';
import 'package:expert_app/presentation/provider/watchlist_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-detail';

  final int id;
  TvDetailPage({required this.id});

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TvDetailNotifier>(
        context,
        listen: false,
      ).fetchTvDetail(widget.id);
      Provider.of<WatchlistNotifier>(
        context,
        listen: false,
      ).loadWatchlistStatus(widget.id, 'tv');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TvDetailNotifier>(
        builder: (context, movieDetailProvider, child) {
          if (movieDetailProvider.tvState == RequestState.Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (movieDetailProvider.tvState == RequestState.Loaded) {
            final tv = movieDetailProvider.tv;
            return Consumer<WatchlistNotifier>(
              builder: (context, watchlistNotifier, child) {
                final isAddedToWatchlist = watchlistNotifier.isAddedToWatchlist;
                return SafeArea(
                  child: DetailContent(
                    tv,
                    movieDetailProvider.tvRecommendations,
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
  final TvDetail tv;
  final List<Tv> recommendations;
  final bool isAddedWatchlist;

  DetailContent(this.tv, this.recommendations, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
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
                            Text(tv.name, style: kHeading5),
                            FilledButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  final mediaItem = tv.toMedia();
                                  await Provider.of<WatchlistNotifier>(
                                    context,
                                    listen: false,
                                  ).addWatchlist(mediaItem);
                                } else {
                                  await Provider.of<WatchlistNotifier>(
                                    context,
                                    listen: false,
                                  ).removeFromWatchlist(tv.id, 'tv');
                                }

                                final message = Provider.of<WatchlistNotifier>(
                                  context,
                                  listen: false,
                                ).watchlistMessage;

                                if (message ==
                                        WatchlistNotifier
                                            .watchlistAddSuccessMessage ||
                                    message ==
                                        WatchlistNotifier
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
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
                            Text(_showGenres(tv.genres)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) =>
                                      Icon(Icons.star, color: kMikadoYellow),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}'),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text('Overview', style: kHeading6),
                            Text(tv.overview),
                            SizedBox(height: 16),
                            Text('Seasons', style: kHeading6),
                            tv.seasons != null && tv.seasons!.isNotEmpty
                                ? Container(
                                    height: 300,
                                    child: ListView.builder(
                                      itemCount: tv.seasons!.length,
                                      itemBuilder: (context, index) {
                                        final season = tv.seasons![index];
                                        return Card(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
                                          child: ExpansionTile(
                                            leading: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${season.posterPath}',
                                                width: 80,
                                                placeholder: (context, url) =>
                                                    Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                errorWidget:
                                                    (
                                                      context,
                                                      url,
                                                      error,
                                                    ) => Container(
                                                      width: 80,
                                                      height: 120,
                                                      color: Colors.grey[800],
                                                      child: Icon(
                                                        Icons
                                                            .image_not_supported,
                                                      ),
                                                    ),
                                              ),
                                            ),
                                            title: Text(
                                              season.name ?? 'No Name',
                                              style: kSubtitle,
                                            ),
                                            subtitle: Text(
                                              'Episodes: ${season.episodeCount}',
                                            ),
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  16.0,
                                                ).copyWith(top: 0),
                                                child: Text(
                                                  (season.overview != null &&
                                                          season
                                                              .overview!
                                                              .isNotEmpty)
                                                      ? season.overview!
                                                      : 'No overview available for this season.',
                                                  style: kBodyText,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Text('No seasons available'),
                            SizedBox(height: 16),
                            Text('Recommendations', style: kHeading6),
                            Consumer<TvDetailNotifier>(
                              builder: (context, data, child) {
                                if (data.recommendationState ==
                                    RequestState.Loading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (data.recommendationState ==
                                    RequestState.Error) {
                                  return Text(data.message);
                                } else if (data.recommendationState ==
                                    RequestState.Loaded) {
                                  return Container(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tv = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TvDetailPage.ROUTE_NAME,
                                                arguments: tv.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                                placeholder: (context, url) =>
                                                    Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
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
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
