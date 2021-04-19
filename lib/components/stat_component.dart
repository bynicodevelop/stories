import 'package:flutter/material.dart';
import 'package:kdofavoris/formatters/int_formatter.dart';

class StatComponent extends StatelessWidget {
  final String label;
  final int stat;

  const StatComponent({
    Key? key,
    required this.label,
    required this.stat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          stat.compact(),
          style: Theme.of(context).textTheme.headline4,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.headline5,
        ),
      ],
    );
  }
}
