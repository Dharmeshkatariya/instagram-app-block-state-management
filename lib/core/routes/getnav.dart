import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/constants.dart';
import '../screens/web_screen_layout.dart';

class GetNav {
  // Navigate to a named route
  static void toNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  // Replace the current route with a named route
  static void offNamed(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  // Navigate to a named route and remove all routes until the predicate returns true
  static void toNamedRemoveUntil(
      BuildContext context, String routeName, RoutePredicate predicate) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, predicate);
  }

  // Navigate to a named route and remove all previous routes
  static void offNamedUntil(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
  }

  // Navigate to a named route with arguments
  static void toNamedWithArgs(
      BuildContext context, String routeName, Object arguments) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  // Pop the current route
  static void back(BuildContext context) {
    Navigator.pop(context);
  }

  // Check if a route with the given name exists in the navigator stack
  static bool isRoutePresent(BuildContext context, String routeName) {
    NavigatorState? navigator = Navigator.of(context);
    if (navigator == null) return false;

    int count = 0;
    navigator.popUntil((route) {
      count++;
      return route.settings.name == routeName;
    });

    return count > 0;
  }

  // Retrieve arguments from the current route
  static dynamic getArguments(BuildContext context) {
    return ModalRoute.of(context)?.settings.arguments;
  }

  // Navigate to a new page with a custom route
  static void toPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // Navigate to a new page and replace the current one with a custom route
  static void offPage(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // Navigate to a new page and remove all previous routes with a custom route
  static void offPageUntil(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => page),
      (route) => false,
    );
  }

  // Pop to the first route in the stack
  static void popToFirst(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  // Check if a route can be popped
  static bool canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }

  // Show a dialog and wait for its result
  static Future<T?> showDialog<T>(BuildContext context, Widget dialog) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return SafeArea(
          child: Builder(
            builder: (BuildContext context) {
              return dialog;
            },
          ),
        );
      },
    );
  }

  static Future<T?> bottomSheet<T>({
    required BuildContext context,
    required Widget sheet,
    Color? backgroundColor,
    BoxConstraints? constraints,
    Color? barrierColor,
    double? elevation,
    Clip? clipBehavior,
    String? barrierLabel,
    bool isScrollControlled = false,
    bool enableDrag = true,
    bool isDismissible = true,
    bool useRootNavigator = false,
    bool useSafeArea = false,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (BuildContext context) {
        return sheet;
      },
      // constraints : constraints ?? Box ,
      barrierColor: barrierColor ?? Colors.white,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: elevation ?? 0,
      clipBehavior: clipBehavior ?? Clip.none,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      useRootNavigator: useRootNavigator,
    );
  }

  // Push a full-screen dialog
  static Future<T?> pushFullScreenDialog<T>(BuildContext context, Widget page) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => page,
        fullscreenDialog: true,
      ),
    );
  }
}

/// currently, I don't use routes methods because there is a lot of run time errors.
/// I use normal Navigator because i don't know how to make Get.to without root.
class Go {
  final BuildContext context;
  Go(this.context);

  Future push({
    required Widget page,
    bool withoutRoot = true,
    bool withoutPageTransition = false,
  }) async {
    if (isThatMobile) {
      PageRoute route = withoutPageTransition
          ? MaterialPageRoute(
              builder: (context) => page, maintainState: !withoutRoot)
          : CupertinoPageRoute(
              builder: (context) => page, maintainState: !withoutRoot);
      return Navigator.of(context, rootNavigator: withoutRoot).push(route);
    } else {
      return Get.to(WebScreenLayout(body: page),
          transition: Transition.noTransition,
          duration: const Duration(milliseconds: 0));
    }
  }

  back() => Navigator.maybePop(context);
}
