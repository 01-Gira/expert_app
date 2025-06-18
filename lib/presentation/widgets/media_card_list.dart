import 'package:cached_network_image/cached_network_image.dart';
import 'package:expert_app/common/constants.dart';
import 'package:expert_app/domain/entities/media.dart';
import 'package:expert_app/presentation/pages/movie_detail_page.dart';
import 'package:expert_app/presentation/pages/tv_detail_page.dart';
import 'package:flutter/material.dart';

class MediaCard extends StatelessWidget {
  final Media item;

  MediaCard(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          if (item.mediaType == 'movie') {
            Navigator.pushNamed(
              context,
              MovieDetailPage.ROUTE_NAME,
              arguments: item.id,
            );
          } else if (item.mediaType == 'tv') {
            Navigator.pushNamed(
              context,
              TvDetailPage.ROUTE_NAME,
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
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${item.posterPath}',
                  width: 80,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
