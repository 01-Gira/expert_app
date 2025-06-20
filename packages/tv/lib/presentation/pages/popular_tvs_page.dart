import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/popular_tvs/popular_tvs_bloc.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';

class PopularTvsPage extends StatefulWidget {
  static const routeName = '/popular-tv';

  const PopularTvsPage({super.key});

  @override
  PopularTvsPageState createState() => PopularTvsPageState();
}

class PopularTvsPageState extends State<PopularTvsPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (mounted) {
        context.read<PopularTvsBloc>().add(FetchPopularTvs());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Popular Tvs')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvsBloc, PopularTvsState>(
          builder: (context, state) {
            if (state is PopularTvsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PopularTvsLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.tvs[index];
                  return TvCard(tv);
                },
                itemCount: state.tvs.length,
              );
            } else if (state is PopularTvsError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Center(child: Text('No popular shows found.'));
            }
          },
        ),
      ),
    );
  }
}
