import 'package:flutter/material.dart';
import '../swipe/swipe_detector.dart';
import 'drawer_navigator.dart';

part 'transformed_container.dart';
part 'inner_drawer_controller.dart';

class InnerDrawer extends StatefulWidget {
  final Widget drawer;
  final InnerDrawerController controller;
  final Color color;
  final Color drawerColor;
  final RouteFactory onGenerateRoute;
  final Object initialArguments;
  final String initialRoute;

  InnerDrawer({
    Key key,
    @required this.drawer,
    @required this.controller,
    this.drawerColor,
    this.color,
    @required this.onGenerateRoute,
    this.initialArguments,
    @required this.initialRoute,
  }) : super(key: key);

  static InnerDrawerState of(BuildContext context) =>
      context.findAncestorStateOfType<InnerDrawerState>();

  @override
  InnerDrawerState createState() => InnerDrawerState();
}

class InnerDrawerState extends State<InnerDrawer> {
  final _navigatorKey = GlobalKey<DrawerNavigatorState>();

  final List<void Function(bool isDrawerOpen)> _listeners = [];

  void addListener(void Function(bool isDrawerOpen) listener) {
    _listeners.add(listener);
  }

  void toggleDrawer() {
    final isDrawerOpen = widget.controller.toggleDrawer();
    for (final listener in _listeners) {
      listener(isDrawerOpen);
    }
  }

  void pushNamed(String name, {Object arguments, bool keepAlive = true}) {
    _navigatorKey.currentState
        .pushNamed(name, arguments: arguments, keepAlive: keepAlive);
    widget.controller.toggleDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: widget.drawerColor ?? Theme.of(context).primaryColor,
          child: widget.drawer,
        ),
        TransformedContainer(
          navigatorKey: _navigatorKey,
          controller: widget.controller,
          color: widget.color,
          initialRoute: widget.initialRoute,
          initialArguments: widget.initialArguments,
          onGenerateRoute: widget.onGenerateRoute,
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _listeners.clear();
  }
}
