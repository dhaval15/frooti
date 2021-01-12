import 'package:flutter/material.dart';
import '../swipe/swipe_detector.dart';

class InnerDrawer extends StatelessWidget {
  final Widget drawer;
  final Widget child;
  final InnerDrawerController controller;
  final Color color;
  final Color drawerColor;

  const InnerDrawer({
    Key key,
    @required this.drawer,
    @required this.child,
    @required this.controller,
    this.drawerColor,
    this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: drawerColor ?? Theme.of(context).primaryColor,
          child: drawer,
        ),
        _TransformedContainer(
          controller: controller,
          child: child,
          color: color,
        ),
      ],
    );
  }
}

class InnerDrawerController {
  final bool open;
  final double scale;
  final double dx;
  final double radius;
  final Duration duration;
  void Function() _onToggleDrawer;

  InnerDrawerController({
    this.open = false,
    this.scale = 0.6,
    this.dx = 0.1,
    this.duration = const Duration(milliseconds: 250),
    this.radius = 24,
  });

  void toggleDrawer() {
    _onToggleDrawer();
  }
}

class _TransformedContainer extends StatefulWidget {
  final Widget child;
  final InnerDrawerController controller;
  final Color color;

  const _TransformedContainer({
    Key key,
    this.child,
    @required this.controller,
    this.color,
  }) : super(key: key);
  @override
  _TransformedContainerState createState() => _TransformedContainerState();
}

class _TransformedContainerState extends State<_TransformedContainer> {
  double dx = 0;
  double dy = 0;
  double radius = 0;
  double scale = 1;
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    isDrawerOpen = widget.controller.open;
    if (isDrawerOpen) {
      dx = MediaQuery.of(context).size.width *
          (widget.controller.scale - widget.controller.dx);
      dy = MediaQuery.of(context).size.height *
          (1 - widget.controller.scale) *
          0.5;
      scale = widget.controller.scale;
      radius = widget.controller.radius;
    }
    widget.controller._onToggleDrawer = _toggleDrawer;
  }

  void _toggleDrawer() {
    if (!isDrawerOpen)
      setState(() {
        dx = MediaQuery.of(context).size.width *
            (widget.controller.scale - widget.controller.dx);
        dy = MediaQuery.of(context).size.height *
            (1 - widget.controller.scale) *
            0.5;
        scale = widget.controller.scale;
        radius = widget.controller.radius;
        isDrawerOpen = true;
      });
    else
      setState(() {
        dx = 0;
        dy = 0;
        radius = 0;
        scale = 1;
        isDrawerOpen = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return SwipeDetector(
      onTap: isDrawerOpen ? _toggleDrawer : null,
      onSwipeLeft: isDrawerOpen
          ? () {
              _toggleDrawer();
            }
          : null,
      onSwipeRight: !isDrawerOpen
          ? () {
              _toggleDrawer();
            }
          : null,
      child: AnimatedContainer(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        transform: Matrix4.translationValues(dx, dy, 0)..scale(scale),
        duration: widget.controller.duration,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: widget.color ?? Theme.of(context).canvasColor,
        ),
        child: SafeArea(
          child: IgnorePointer(
            ignoring: isDrawerOpen,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
