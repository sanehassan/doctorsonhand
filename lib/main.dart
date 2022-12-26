import 'package:doctors_on_hand/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:doctors_on_hand/screens/welcome_screen.dart';
import 'package:doctors_on_hand/theme/theme_manager.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

//List<MultiProvider> providers = [];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
      ],
      child: Consumer<ThemeManager>(
        child: WelcomeScreen(),
        builder: (c, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.selectedThemeMode,
            home: child,
          );
        },
      ),
    );

    // ChangeNotifierProvider(
    //   create: (context) => ThemeManager(),
    //   child: MaterialApp(
    //     themeMode: Provider.of<ThemeManager>(context).selectedThemeMode,
    //     home: WelcomeScreen(),
    //   ),
    // );
  }
}