import 'package:flutter/material.dart';
import '../views/page/login_page.dart';
import '../views/page/signup_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? leftActions;
  final Widget? logo;
  final List<Widget>? rightActions;

  CustomAppBar({this.leftActions, this.logo, this.rightActions});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(70.0), // Définit la hauteur de l'AppBar
      child: AppBar(
        backgroundColor: Colors.teal.shade50, // La couleur de fond de l'AppBar
        automaticallyImplyLeading: false, // Cache le widget principal
        flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top), // Assure l'ajustement correct sous la barre d'état
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Boutons à gauche
                  Row(mainAxisSize: MainAxisSize.min, children: leftActions ?? []),
                  // Logo au centre
                  Expanded(
                    child: Center(
                      child: logo ?? Image.asset('assets/images/logo/logo.png', fit: BoxFit.contain),
                    ),
                  ),
                  // Actions à droite
                  Row(mainAxisSize: MainAxisSize.min, children: rightActions ?? [
                    IconButton(icon: Icon(Icons.login, color: Colors.black54), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()))),
                    IconButton(icon: Icon(Icons.app_registration, color: Colors.black54), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()))),
                  ]),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70.0); // Assure la cohérence de la hauteur avec PreferredSize
}
