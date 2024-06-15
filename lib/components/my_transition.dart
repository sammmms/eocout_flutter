import 'package:flutter/material.dart';

Route<T> slideInFromBottom<T>(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

Route<T> slideInFromRight<T>(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

Route<T> slideInFromLeft<T>(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

Route<T> slideInFromTop<T>(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, -1.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

Route<T> fadeIn<T>(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

Route<T> fadeOut<T>(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: Tween<double>(begin: 1, end: 0).animate(animation),
        child: child,
      );
    },
  );
}

Route<T> noAnimation<T>(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

enum TransitionType {
  slideInFromBottom,
  slideInFromRight,
  slideInFromLeft,
  slideInFromTop,
  fadeIn,
  fadeOut,
  noAnimation,
}

void navigateTo(BuildContext context, Widget page,
    {bool replace = false,
    TransitionType transition = TransitionType.fadeIn,
    bool clearStack = false}) {
  late Route Function(Widget) animation;

  switch (transition) {
    case TransitionType.slideInFromBottom:
      animation = slideInFromBottom;
      break;
    case TransitionType.slideInFromRight:
      animation = slideInFromRight;
      break;
    case TransitionType.slideInFromLeft:
      animation = slideInFromLeft;
      break;
    case TransitionType.slideInFromTop:
      animation = slideInFromTop;
      break;
    case TransitionType.fadeIn:
      animation = fadeIn;
      break;
    case TransitionType.fadeOut:
      animation = fadeOut;
      break;
    case TransitionType.noAnimation:
      animation = noAnimation;
      break;
  }

  if (clearStack) {
    Navigator.pushAndRemoveUntil(context, animation(page), (route) => false);
  } else if (replace) {
    Navigator.pushReplacement(context, animation(page));
  } else {
    Navigator.push(context, animation(page));
  }
}
