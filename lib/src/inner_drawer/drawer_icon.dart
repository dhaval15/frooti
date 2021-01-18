import 'package:flutter/material.dart';
import 'inner_drawer.dart';

class DrawerIcon extends StatelessWidget {
  final Icon icon;
  final Color color;

  const DrawerIcon({
    Key key,
    this.icon,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon ?? Icon(Icons.menu),
      color: color,
      onPressed: () {
        InnerDrawer.of(context).toggleDrawer();
      },
    );
  }
}
