import 'package:core/common/state_enum.dart';
import 'package:core/common/utils.dart';
import 'package:watchlist/presentation/provider/watchlist_notifier.dart';
import 'package:search/presentation/widgets/media_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistPage extends StatefulWidget {
  static const routeName = '/watchlist';

  const WatchlistPage({super.key});

  @override
  WatchlistPageState createState() => WatchlistPageState();
}

class WatchlistPageState extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        Provider.of<WatchlistNotifier>(
          context,
          listen: false,
        ).fetchWatchlistItems();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Provider.of<WatchlistNotifier>(
      context,
      listen: false,
    ).fetchWatchlistItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Watchlist')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<WatchlistNotifier>(
          builder: (context, data, child) {
            if (data.watchlistState == RequestState.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (data.watchlistState == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final item = data.watchlistItems[index];
                  return MediaCard(item);
                },
                itemCount: data.watchlistItems.length,
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
