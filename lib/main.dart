import 'package:Ahteeg/views/decrypt_page.dart';
import 'package:Ahteeg/views/encrypt_page.dart';
import 'package:Ahteeg/views/hash_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
            primaryColorDark: Colors.blue[900],
            accentColor: Colors.blueGrey,
            cardColor: Colors.lightBlue[50],
            backgroundColor: Colors.white,
            errorColor: Colors.red[200],
            brightness: Brightness.light,
        )),
      darkTheme: ThemeData.from(colorScheme: ColorScheme(
            primary: Color(0xFFBB86FC),
            primaryVariant: Color(0xFF3700B3),
            secondary: Color(0xFF03DAC5),
            background: Color(0xFF121212),
            surface: Color(0xFF121212),
            error: Color(0xFFCF6679),
            secondaryVariant: Color(0xFF26A69A),
            onPrimary: Color(0xFF212121),
            onSecondary: Color(0xFF212121),
            onBackground: Color(0xFFFFFFFF),
            onSurface: Color(0xFFFFFFFF),
            onError: Color(0xFF212121),
            brightness: Brightness.dark,
        )),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'Encrypt'),
                Tab(text: 'Decrypt'),
                Tab(text: 'Hash'),
              ],
            ),
            title: Text('Not just any other assignment'),
          ),
          body: TabBarView(
            children: [
              EncryptPage(),
              DecryptPage(),
              HashPage(),
            ],
          ),
        ),
      ),
    );
  }
}