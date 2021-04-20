import 'package:flutter/material.dart';

class RemoveTransitionPageRoute extends MaterialPageRoute {
  RemoveTransitionPageRoute({builder, RouteSettings? settings})
      : super(
          builder: builder,
          settings: settings,
        );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}
