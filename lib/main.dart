import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tallercall/src/pages/appointment_page.dart';

import 'package:tallercall/src/pages/home_page.dart';
import 'package:tallercall/src/pages/login_page.dart';
import 'package:tallercall/src/pages/profile_page.dart';
import 'package:tallercall/src/pages/register_page.dart';
import 'package:tallercall/src/pages/speaking_page.dart';
import 'package:tallercall/src/pages/welcome_page.dart';
import 'package:tallercall/src/providers/info.dart';
import 'package:tallercall/src/services/user_prefs.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = new UserPrefs();
  await prefs.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    final _prefs = UserPrefs();

    return ChangeNotifierProvider(
      create: (context) => Info(),
      child: MaterialApp(
        title: 'Productos',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('es','ES'),
        ],
        theme: ThemeData(
          backgroundColor: Colors.white,
          primaryColor: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: _prefs.lastPage,
        routes: {
          'home'             : (context)  => HomePage(),
          'appointment'      : (context)  => AppointmentPage(),
          'speaking'         : (context)  => SpeakingPage(),
          'login'            : (context)  => LoginPage(),
          'register'         : (context)  => RegisterPage(),
          'welcome'          : (context)  => WelcomePage(),
          'profile'          : (context)  => ProfilePage(),
        },
      ),
    );
  }
}

