import 'package:equatable/equatable.dart';

class Media extends Equatable {
  Media({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.mediaType,
  });

  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final String mediaType;

  @override
  List<Object?> get props => [id, title, posterPath, overview, mediaType];
}
