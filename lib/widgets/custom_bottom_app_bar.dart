import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smig_app/views/page/home_page.dart';
import 'package:smig_app/views/page/ressource_list_page.dart';
import 'package:smig_app/views/page/ressource_creation_page.dart';
import 'package:smig_app/views/page/ressource_page.dart';
import 'package:smig_app/views/page/utilisateur_modification_page.dart';
import 'package:smig_app/views/page/utilisateur_profile.dart';
import 'package:smig_app/views/page/utilisateur_search_page.dart';

import '../services/auth_service.dart';
import '../views/page/commentaire_page.dart';
import '../views/page/login_page.dart';
import '../views/screen/transition_page.dart';

class CustomBottomAppBar extends StatefulWidget implements PreferredSizeWidget {

  const CustomBottomAppBar({Key? key}) : super(key: key);

  @override
  _CustomBottomAppBarState createState() => _CustomBottomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(35.0);
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 3, left: 3, right: 3, top: 3),
        height: widget.preferredSize.height,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: Color(0xFF03989E),
            width: 3,
          ),
          borderRadius: BorderRadius.all(Radius.circular(60)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                _controller
                  ..reset()
                  ..forward();
                Navigator.of(context).pushReplacement(CustomMaterialPageRoute(
                  builder: (context) => HomePage(),
                ));


              },
              child: SizedBox(
                child: Lottie.asset(
                  'assets/appBar/home_green.json',
                  controller: _controller,
                  onLoaded: (composition) {
                    _controller
                      ..duration = composition.duration
                      ..forward();
                  },
                ),
              ),
            ),
       // SizedBox(width: 30),
            GestureDetector(
              onTap: () async{
                _controller
                  ..reset()
                  ..forward();
                //await AuthService().logout();
                Navigator.of(context).pushReplacement(CustomMaterialPageRoute(
                  builder: (context) => UserSearchPage(),
                ));

              },
              child: SizedBox(
                child: Lottie.asset(
                  'assets/appBar/search_green.json',
                  controller: _controller,
                  onLoaded: (composition) {
                    _controller
                      ..duration = composition.duration
                      ..forward();
                  },
                ),
              ),
            ),
           // Spacer(flex: 1),
            GestureDetector(
              onTap: () {
                _controller
                  ..reset()
                  ..forward();
                Navigator.of(context).pushReplacement(CustomMaterialPageRoute(
                  builder: (context) => RessourceCreationPage(),
                ));

              },
              child: SizedBox(
                child: Lottie.asset(
                  'assets/appBar/add_green.json',
                  controller: _controller,
                  onLoaded: (composition) {
                    _controller
                      ..duration = composition.duration
                      ..forward();
                  },
                ),
              ),
            ),
           // Spacer(flex: 1),
            GestureDetector(
              onTap: () {
                _controller
                  ..reset()
                  ..forward();
                Navigator.of(context).pushReplacement(CustomMaterialPageRoute(
                  builder: (context) => CommentsPage(ressourceId: 28),
                ));

              },
              child: SizedBox(
                child: Lottie.asset(
                  'assets/appBar/stats_green.json',
                  controller: _controller,
                  onLoaded: (composition) {
                    _controller
                      ..duration = composition.duration
                      ..forward();
                  },
                ),
              ),
            ),
           // SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                _controller
                  ..reset()
                  ..forward();
                Navigator.of(context).pushReplacement(CustomMaterialPageRoute(
                  builder: (context) => UserProfile(),
                ));
              },
              child: SizedBox(
                child: Lottie.asset(
                  'assets/appBar/user_green.json',
                  controller: _controller,
                  onLoaded: (composition) {
                    _controller
                      ..duration = composition.duration
                      ..forward();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
