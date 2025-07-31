import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/Provider/savedLocation_provider.dart';
import 'package:weather_app/widgets/appbar.dart';
import 'package:weather_app/widgets/footer.dart';

class Watchlist extends ConsumerWidget {
  const Watchlist({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlist = ref.watch(savedLocationProvider);
    return Scaffold(
      appBar: Appbar(heading: 'Watchlist'),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: ListView.builder(itemCount: watchlist.length,
                 itemBuilder: (BuildContext context, int index){
                    final location = watchlist[index];
                    return Card(
                      child: ListTile(
                        title: Text("${location.name},${location.country} ${location.temp}"),
                        subtitle: Text("${location.description}, H:${location.high}, L:${location.low}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            ref
                                .read(savedLocationProvider.notifier)
                                .removeLocation(location);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Location removed from watchlist'),
                              ),
                            );
                          },
                        ),


                      ),
                    );
                },
                  
                )
              ),
            ),
          ),
          // Footer at the bottom as other screens.
          Positioned(bottom: 0, left: 0, right: 0, child: Footer(null, null)),
        ],
      ),
    );
  }
}
