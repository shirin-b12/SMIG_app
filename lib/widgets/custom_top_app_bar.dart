import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTopAppBar extends StatelessWidget implements PreferredSizeWidget {

  CustomTopAppBar();

  @override
  Size get preferredSize => Size.fromHeight(40.0);

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
                  SvgPicture.asset(
                    'assets/images/s1.svg',
                    semanticsLabel: 'My SVG Image',
                    height: 100,
                    width: 70,
                  ),

                ],
              ),
            );
          },
        ),
      ),
    );
  }
}