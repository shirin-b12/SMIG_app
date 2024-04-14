import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:smig_app/services/auth_service.dart';
import 'package:smig_app/views/page/favoris_page.dart';
import 'package:smig_app/views/screen/signup_or_login/signup_or_login.dart';

class CustomTopAppBar extends StatefulWidget implements PreferredSizeWidget {

  const CustomTopAppBar({Key? key}) : super(key: key);

  @override
  _CustomTopAppBarState createState() => _CustomTopAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(40.0);
}
  class _CustomTopAppBarState extends State<CustomTopAppBar> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(10.0),
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              child:  Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 3, left: 3, right: 3, top: 3),
                    child: Lottie.asset(
                      'assets/appBar/RE_green.json',
                      repeat: false,
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: const EdgeInsets.only(bottom: 3, left: 3, right: 3, top: 3),
                    child : GestureDetector(
                      onTap: () {
                        _controller
                          ..reset()
                          ..forward();
                        //AuthService().logout();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => FavorisListPage()));

                      },
                      child: SizedBox(
                        child: Lottie.asset(
                          'assets/appBar/fav_green.json',
                          controller: _controller,
                          onLoaded: (composition) {
                            _controller
                              ..duration = composition.duration
                              ..forward();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}