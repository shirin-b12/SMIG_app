import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../services/auth_service.dart';
import '../views/page/login_page.dart';

class CustomBottomAppBar extends StatefulWidget implements PreferredSizeWidget {

  const CustomBottomAppBar({Key? key}) : super(key: key);

  @override
  _CustomBottomAppBarState createState() => _CustomBottomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(50.0);
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
            color: Color(0xFF000091),
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
              },
              child: SizedBox(
                child: Lottie.asset(
                  'assets/appBar/home.json',
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
                await AuthService().logout();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: SizedBox(
                child: Lottie.asset(
                  'assets/appBar/search.json',
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
              },
              child: SizedBox(
                child: Lottie.asset(
                  'assets/appBar/add.json',
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
              },
              child: SizedBox(
                child: Lottie.asset(
                  'assets/appBar/stats.json',
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
              },
              child: SizedBox(
                child: Lottie.asset(
                  'assets/appBar/user.json',
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
