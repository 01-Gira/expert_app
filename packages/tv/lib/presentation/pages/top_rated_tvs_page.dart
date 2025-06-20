import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/top_rated_tvs/top_rated_tvs_bloc.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';

class TopRatedTvsPage extends StatefulWidget {
  static const routeName = '/top-rated-tv';

  const TopRatedTvsPage({super.key});

  @override
  TopRatedTvsPageState createState() => TopRatedTvsPageState();
}

class TopRatedTvsPageState extends State<TopRatedTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<TopRatedTvsBloc>().add(FetchTopRatedTvs());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Rated Tvs')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvsBloc, TopRatedTvsState>(
          builder: (context, state) {
            if (state is TopRatedTvsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TopRatedTvsLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.tvs[index];
                  return TvCard(tv);
                },
                itemCount: state.tvs.length,
              );
            } else if (state is TopRatedTvsError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Center(child: Text('No top rated shows found.'));
            }
          },
        ),
      ),
    );
  }
}
