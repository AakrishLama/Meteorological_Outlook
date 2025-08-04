import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/Provider/savedLocation_provider.dart';
import 'package:weather_app/widgets/appbar.dart';
import 'package:weather_app/widgets/footer.dart';

class Watchlist extends ConsumerWidget {
  const Watchlist({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlist = ref.watch(savedLocationProvider);
    return Theme(
      data: ThemeData.dark( ),
      child: Scaffold(
        appBar: Appbar(heading: 'Watchlist'),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: ListView.builder(
                    itemCount: watchlist.length,
                    itemBuilder: (BuildContext context, int index) {
                      final location = watchlist[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: AssetImage(
                                location.backgroundImage,
                              ), 
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken,
                              ),
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            onTap: () => GoRouter.of(context).go(
                              "/?latitude=${location.latitude}&longitude=${location.longitude}",
                            ),
                            title: Text(
                              "${location.name}, ${location.country}  •  ${location.temp}°C",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              "${location.description}, H:${location.high}, L:${location.low}\nTap to view full weather info",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.white),
                              onPressed: () {
                                ref
                                    .read(savedLocationProvider.notifier)
                                    .removeLocation(location);
                                Fluttertoast.showToast(
                                  msg: "Location removed from watchlist",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            // Footer at the bottom as other screens.
            Positioned(bottom: 0, left: 0, right: 0, child: Footer(null, null)),
          ],
        ),
      ),
    );
  }
}
