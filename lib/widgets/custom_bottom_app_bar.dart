import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smig_app/services/api_service.dart';
import 'package:smig_app/views/page/home_page.dart';
import 'package:smig_app/views/page/ressource_list_page.dart';
import 'package:smig_app/views/page/ressource_creation_page.dart';
import 'package:smig_app/views/page/ressource_modification_page.dart';
import 'package:smig_app/views/page/ressource_page.dart';
import 'package:smig_app/views/page/utilisateur_modification_page.dart';
import 'package:smig_app/views/page/utilisateur_profile.dart';
import 'package:smig_app/views/page/search_page.dart';
import 'package:smig_app/views/screen/signup_or_login/signup_or_login.dart';

import '../models/utilisateur.dart';
import '../services/auth_service.dart';
import '../views/page/commentaire_page.dart';
import '../views/page/create_tag_cat_type.dart';
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
        height: widget.preferredSize.height,
        decoration: const BoxDecoration(
          color: Color(0xFF03989E)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                _controller
                  ..reset()
                  ..forward();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
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
            GestureDetector(
              onTap: () async{
                _controller
                  ..reset()
                  ..forward();
                //await AuthService().logout();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => UserSearchPage()));
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
            GestureDetector(
              onTap: () {
                _controller
                  ..reset()
                  ..forward();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RessourceCreationPage()));
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.translate(
                    offset: Offset(0, -15),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Lottie.asset(
                        'assets/appBar/add_green.json',
                        controller: _controller,
                        onLoaded: (composition) {
                          _controller
                            ..duration = composition.duration
                            ..forward();
                        },
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                _controller
                  ..reset()
                  ..forward();
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
            GestureDetector(
              onTap: () async {
                _controller
                  ..reset()
                  ..forward();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => UserProfile()));
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
