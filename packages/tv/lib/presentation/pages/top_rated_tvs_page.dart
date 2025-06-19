import 'package:core/common/state_enum.dart';
import 'package:tv/presentation/provider/top_rated_tvs_notifier.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        Provider.of<TopRatedTvsNotifier>(
          context,
          listen: false,
        ).fetchTopRatedTvs();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Rated Tvs')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TopRatedTvsNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (data.state == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = data.tvs[index];
                  return TvCard(tv);
                },
                itemCount: data.tvs.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
