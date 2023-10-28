import 'package:flutter/cupertino.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  CustomPageRoute({
    required this.child,
}) : super(
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) => child,
  ) ;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) => ScaleTransition(
      scale: animation,
      child: child,
  );
}

class CustomPageRouteDirection extends PageRouteBuilder {
  final Widget child;
  final AxisDirection direction;

  CustomPageRouteDirection({
    required this.child,
    this.direction = AxisDirection.right,
  }) : super(
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) => child,
  ) ;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) => SlideTransition(
    position: Tween<Offset>(
        begin: getBeginOffset(),
        end: Offset.zero).animate(animation),
    child: child,
  );

  Offset getBeginOffset(){
    switch(direction) {
      case AxisDirection.up:
        return const Offset(0, 1);

      case AxisDirection.down:
        return const Offset(0, -1);

      case AxisDirection.right:
        return const Offset(-1, 0);

      case AxisDirection.left:
        return const Offset(1, 0);
    }
  }

}