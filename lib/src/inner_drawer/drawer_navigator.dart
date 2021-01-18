import 'package:flutter/material.dart';

class DrawerNavigator extends StatefulWidget {
  final RouteFactory onGenerateRoute;
  final Object initialArguments;
  final String initialRoute;
  final Duration duration;

  const DrawerNavigator({
    Key key,
    this.onGenerateRoute,
    this.initialArguments,
    this.duration = const Duration(milliseconds: 250),
    this.initialRoute,
  }) : super(key: key);

  static DrawerNavigatorState of(BuildContext context) =>
      context.findAncestorStateOfType<DrawerNavigatorState>();

  @override
  DrawerNavigatorState createState() => DrawerNavigatorState();
}

class DrawerNavigatorState extends State<DrawerNavigator> {
  final Map<String, MaterialPageRoute> _pages = {};
  MaterialPageRoute _current;

  @override
  void initState() {
    super.initState();
    _current = widget.onGenerateRoute(RouteSettings(
      name: widget.initialRoute,
      arguments: widget.initialArguments,
    ));
    _pages[widget.initialRoute] = _current;
  }

  void pushNamed(String name, {Object arguments, bool keepAlive = true}) {
    setState(() {
      _current = _pages[_current];
      if (_current == null) {
        _current = widget
            .onGenerateRoute(RouteSettings(name: name, arguments: arguments));
        if (keepAlive) _pages[name] = _current;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      switchInCurve: Curves.easeInCubic,
      switchOutCurve: Curves.easeOutCubic,
      child: _current.buildContent(context),
      duration: widget.duration,
    );
  }
}
