part of 'inner_drawer.dart';

class InnerDrawerController {
  final bool open;
  final double scale;
  final double dx;
  final double radius;
  final Duration duration;
  bool Function() _onToggleDrawer;

  InnerDrawerController({
    this.open = false,
    this.scale = 0.6,
    this.dx = 0.1,
    this.duration = const Duration(milliseconds: 250),
    this.radius = 24,
  });

  bool toggleDrawer() {
    return _onToggleDrawer();
  }
}
