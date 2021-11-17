import 'package:flutter/material.dart';
import 'package:flutter_weather/preferences/language.dart';
import 'package:flutter_weather/preferences/theme_colors.dart';
import 'screens/loading_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

void main() {
  initialize();
}

Future<void> initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Language.initialise();
  await DotEnv.load(fileName: "configs/.env");
  ThemeColors.initialise().then(
    (value) => runApp(
      WeatherToday(),
    ),
  );

}

class WeatherToday extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "Weather Today",
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.teal,
        //backgroundColor: Colors.black,
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.teal),
      ),
      debugShowCheckedModeBanner: true,
      home: LoadingScreen(checkDefaultLocation: true,),
    );
  }
}
