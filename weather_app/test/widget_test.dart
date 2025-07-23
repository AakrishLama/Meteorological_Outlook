import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/Screens/getLocation.dart'; // This should be the file where MyLocation is defined
import 'package:weather_app/Screens/weather.dart';     // This should be the file where Weather is defined

void main() {
  testWidgets('Navigates to location and finds Refresh button', (WidgetTester tester) async {
    final goRouter = GoRouter(
      routes: [
        GoRoute(path: "/", builder: (context, state) => const MyLocation()),
        GoRoute(path: "/weatherInfo", builder: (context, state) =>  Weather()),
      ],
    );

    await tester.pumpWidget(MyWidget(goRouter: goRouter));
    await tester.pumpAndSettle(); // Let animations complete

    // Verify "Refresh Location" button is present
    expect(find.text('Refresh Location'), findsOneWidget);
  });
}
