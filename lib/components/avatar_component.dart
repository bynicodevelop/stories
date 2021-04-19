import 'package:flutter/material.dart';

class AvatarComponent extends StatelessWidget {
  final String avatar;
  final double size;
  final double borderRadius;

  const AvatarComponent({
    Key? key,
    required this.avatar,
    this.size = 15.0,
    this.borderRadius = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundColor: Colors.green[800],
      child: Padding(
        padding: EdgeInsets.all(borderRadius),
        child: CircleAvatar(
          radius: size - borderRadius,
          backgroundColor: Colors.grey[800],
          backgroundImage: NetworkImage(this.avatar),
        ),
      ),
    );
  }
}
