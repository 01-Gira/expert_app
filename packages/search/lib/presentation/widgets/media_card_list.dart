import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:search/domain/entities/media.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'package:flutter/material.dart';

class MediaCard extends StatelessWidget {
  final Media item;

  const MediaCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          if (item.mediaType == 'movie') {
            Navigator.pushNamed(
              context,
              MovieDetailPage.routeName,
              arguments: item.id,
            );
          } else if (item.mediaType == 'tv') {
            Navigator.pushNamed(
              context,
              TvDetailPage.routeName,
              arguments: item.id,
            );
          }
        },
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Card(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16 + 80 + 16,
                  bottom: 8,
                  right: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title ?? 'No Title',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kHeading6,
                    ),
                    SizedBox(height: 16),
                    Text(
                      item.overview ?? 'No Overview',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, bottom: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: (item.posterPath != null && item.posterPath!.isNotEmpty)
                    ? CachedNetworkImage(
                        imageUrl: '$baseImageUrl${item.posterPath}',
                        width: 80,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )
                    : Container(
                        color: Colors.grey[800],
                        width: 80,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
