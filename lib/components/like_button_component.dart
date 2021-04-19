import 'package:flutter/material.dart';
import 'package:kdofavoris/formatters/int_formatter.dart';

class LikeButtonComponent extends StatelessWidget {
  final Function onLike;
  final int likes;

  const LikeButtonComponent({
    Key? key,
    required this.onLike,
    required this.likes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 6.0,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                  size: 35.0,
                ),
                onPressed: () => onLike(),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                likes.compact(),
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        )
      ],
    );
  }
}
