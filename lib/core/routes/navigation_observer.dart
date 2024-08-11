import '../../export.dart';

class AppNavigateObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute?.settings.name == Routes.homeScreen) {}
  }

  @override
  void didPush(Route route, Route? previousRoute) {}
}
