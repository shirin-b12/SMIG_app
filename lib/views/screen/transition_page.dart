import 'package:flutter/material.dart';

class CustomMaterialPageRoute<T> extends MaterialPageRoute<T> {
  final Duration transitionDurationCustom;

  CustomMaterialPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    this.transitionDurationCustom = const Duration(milliseconds: 100),
  }) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }

  @override
  Duration get transitionDuration => transitionDurationCustom;
}
//TODO : utiliser cette classe pour les transition mais faire en sorte qu'il n'y ai pas de bouton retour