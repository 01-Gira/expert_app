import 'package:movie/presentation/provider/movie_list_notifier.dart';
import 'package:mockito/annotations.dart';
import 'package:tv/presentation/bloc/tv_list/tv_list_bloc.dart';

@GenerateMocks([
  // ... mock lain yang sudah ada
  MovieListNotifier,
  TvListBloc,
])
void main() {}
