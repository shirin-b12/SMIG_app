import 'package:flutter/material.dart';
import 'package:smig_app/views/page/login_page.dart';
import 'package:smig_app/views/page/ressource_creation_page.dart';
import 'package:smig_app/views/page/ressource_list_page.dart';
import 'package:smig_app/views/page/signup_page.dart';
import 'package:smig_app/views/screen/splash/splash_screen.dart';
import 'views/page/home_page.dart';
import 'views/page/commentaire_page.dart';
import 'views/page/utilisateur_profile.dart';
import 'views/page/search_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMIG App',
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/ressource_list': (context) => RessourceListPage(),
        '/ressource_creation': (context) => RessourceCreationPage(),
        // Ajoutez les nouvelles routes ici
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/search':
            return CustomPageRoute(builder: (context) => UserSearchPage());
          case '/add':
            return CustomPageRoute(builder: (context) => RessourceCreationPage());
          case '/stats':
            return CustomPageRoute(builder: (context) => CommentsPage(ressourceId: 28));
          case '/user':
            return CustomPageRoute(builder: (context) => UserProfile());
          default:
            return CustomPageRoute(builder: (context) => HomePage());
        }
      },
    );
  }
}

class CustomPageRoute extends MaterialPageRoute {
  CustomPageRoute({required WidgetBuilder builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 1000);
}
