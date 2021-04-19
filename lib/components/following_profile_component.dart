import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kdofavoris/components/card_story_component.dart';
import 'package:kdofavoris/services/user/user_bloc.dart';

class FollowingProfileComponent extends StatefulWidget {
  const FollowingProfileComponent({Key? key}) : super(key: key);

  @override
  _FollowingProfileComponentState createState() =>
      _FollowingProfileComponentState();
}

class _FollowingProfileComponentState extends State<FollowingProfileComponent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserInitialState && state.followings.length > 0) {
          return GridView.count(
            scrollDirection: Axis.horizontal,
            childAspectRatio: 16 / 9,
            primary: false,
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 1,
            children: state.followings.asMap().entries.map(
              (entry) {
                return CardStoryComponent(
                  profileModel: entry.value,
                );
              },
            ).toList(),
          );
        } else if (state is UserInitialState && state.followings.length == 0) {
          return Center(
            child: Container(
              child: Text("Aucun followings trouvé"),
            ),
          );
        }

        return SpinKitThreeBounce(
          color: Colors.black,
          size: 15.0,
        );
      },
    );
  }
}
