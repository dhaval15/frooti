part of 'inner_drawer.dart';

class TransformedContainer extends StatefulWidget {
  final InnerDrawerController controller;
  final Color color;
  final RouteFactory onGenerateRoute;
  final Object initialArguments;
  final String initialRoute;
  final GlobalKey<DrawerNavigatorState> navigatorKey;

  const TransformedContainer({
    Key key,
    @required this.controller,
    this.color,
    this.onGenerateRoute,
    this.initialArguments,
    this.initialRoute,
    this.navigatorKey,
  }) : super(key: key);
  @override
  _TransformedContainerState createState() => _TransformedContainerState();
}

class _TransformedContainerState extends State<TransformedContainer> {
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

  bool _toggleDrawer() {
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
    return isDrawerOpen;
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
              child: DrawerNavigator(
                key: widget.navigatorKey,
                initialRoute: widget.initialRoute,
                initialArguments: widget.initialArguments,
                onGenerateRoute: widget.onGenerateRoute,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
