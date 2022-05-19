import 'package:flutter/material.dart';
import 'package:flash_notes/pages/home_page.dart';

void main() => runApp(const MyApp());

ColorScheme colorScheme = const ColorScheme(
  primary: Color.fromARGB(255, 191, 198, 131),
  secondary: Color(0xffCCC2DC),
  surface: Color(0xff28262D),
  background: Color.fromARGB(255, 39, 39, 41),
  error: Color(0xffF2B8B5),
  onPrimary: Color.fromARGB(255, 50, 26, 101),
  onSecondary: Color.fromARGB(255, 51, 45, 65),
  onSurface: Color(0xffE6E1E5),
  onBackground: Color(0xffE6E1E5),
  onError: Color(0xff601410),
  brightness: Brightness.dark,
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flash Notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: colorScheme,
        primaryColor: const Color(0xffD0BCFF),
      ),
      home: const HomePage(title: 'Flash Notes'),
    );
  }
}
