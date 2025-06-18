import 'package:ditonton/data/models/media_model.dart';
import 'package:equatable/equatable.dart';

class MediaResponse extends Equatable {
  final List<MediaModel> mediaList;

  MediaResponse({required this.mediaList});

  factory MediaResponse.fromJson(Map<String, dynamic> json) => MediaResponse(
    mediaList: List<MediaModel>.from(
      (json["results"] as List)
          .map((x) => MediaModel.fromJson(x))
          .where(
            (element) =>
                element.mediaType != 'person' && element.mediaType != 'unknown',
          ),
    ),
  );

  Map<String, dynamic> toJson() => {
    "results": List<dynamic>.from(mediaList.map((x) => x.toJson())),
  };

  @override
  List<Object> get props => [mediaList];
}
