import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/Provider/savedLocation_provider.dart';
import 'package:weather_app/widgets/appbar.dart';
import 'package:weather_app/widgets/footer.dart';

class Watchlist extends ConsumerStatefulWidget {
  const Watchlist({super.key});

  @override
  ConsumerState<Watchlist> createState() => _WatchlistState();
}

class _WatchlistState extends ConsumerState<Watchlist> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Controller for staggered animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // total duration
    );

    _controller.forward(); // start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final watchlist = ref.watch(savedLocationProvider);
    final totalItems = watchlist.length;

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: Appbar(heading: 'Watchlist'),
        body: Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: totalItems,
              itemBuilder: (context, index) {
                final location = watchlist[index];

                // create animation interval for staggered effect
                final start = index * 0.1;
                final end = start + 0.4;

                final animation = Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Interval(
                      start.clamp(0.0, 1.0),
                      end.clamp(0.0, 1.0),
                      curve: Curves.easeOut,
                    ),
                  ),
                );

                return SlideTransition(
                  position: animation,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: AssetImage(location.backgroundImage),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                            ref.read(savedLocationProvider.notifier).removeLocation(location);
                            Fluttertoast.showToast(
                              msg: "Location removed from watchlist",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            // Sticky footer
            Positioned(bottom: 0, left: 0, right: 0, child: Footer(null, null)),
          ],
        ),
      ),
    );
  }
}
