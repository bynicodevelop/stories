import 'package:flutter/material.dart';

enum DeviceDetectorType { phone, tablet, desktop }

class DeviceDetectorBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceDetectorType type) builder;

  const DeviceDetectorBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 481) {
          return builder(context, DeviceDetectorType.phone);
        }

        if (constraints.maxWidth > 481 && constraints.maxWidth < 960) {
          return builder(context, DeviceDetectorType.tablet);
        }

        return builder(context, DeviceDetectorType.desktop);
      },
    );
  }
}
