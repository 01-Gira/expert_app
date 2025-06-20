import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/entities/genre.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:core/common/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TvDetailPage extends StatefulWidget {
  static const routeName = '/tv-detail';

  final int id;
  const TvDetailPage({super.key, required this.id});

  @override
  TvDetailPageState createState() => TvDetailPageState();
}

class TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<TvDetailBloc>().add(FetchTvDetail(widget.id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TvDetailBloc, TvDetailState>(
        listener: (context, state) {
          if (state.watchlistMessage.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.watchlistMessage)));
          }
        },
        builder: (context, state) {
          if (state.tvState == RequestState.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.tvState == RequestState.loaded && state.tv != null) {
            return SafeArea(
              child: DetailContent(
                tv: state.tv!,
                recommendations: state.tvRecommendations,
                isAddedWatchlist: state.isAddedToWatchlist,
              ),
            );
          } else if (state.tvState == RequestState.error) {
            return Text(state.message);
          } else {
            return Container();
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

  const DetailContent({
    super.key,
    required this.tv,
    required this.recommendations,
    required this.isAddedWatchlist,
  });

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
                              onPressed: () {
                                if (!isAddedWatchlist) {
                                  context.read<TvDetailBloc>().add(
                                    AddToWatchlist(tv),
                                  );
                                } else {
                                  context.read<TvDetailBloc>().add(
                                    RemoveFromWatchlist(tv),
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
                                ? SizedBox(
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
                            BlocBuilder<TvDetailBloc, TvDetailState>(
                              builder: (context, state) {
                                if (state.recommendationState ==
                                    RequestState.loading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state.recommendationState ==
                                    RequestState.loaded) {
                                  return SizedBox(
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
                                                TvDetailPage.routeName,
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
    return genres.map((e) => e.name).toList().join(',');
  }
}
