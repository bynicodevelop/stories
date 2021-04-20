import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kdofavoris/components/stat_component.dart';
import 'package:kdofavoris/services/user/user_bloc.dart';

class ProfileHeaderComponent extends StatelessWidget {
  const ProfileHeaderComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserInitialState && state.userModel.uid.isNotEmpty) {
          return Container(
            padding: const EdgeInsets.symmetric(
              vertical: 30.0,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12.0,
                  ),
                  child: Card(
                    elevation: 5.0,
                    shape: CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: CircleAvatar(
                      radius: 60.0,
                      backgroundImage: NetworkImage(
                        state.userModel.avatar,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8.0,
                  ),
                  child: Text(
                    state.userModel.displayName,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                Text(
                  "@${state.userModel.slug}",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StatComponent(
                        label: "Abonnées",
                        stat: state.followers.length,
                      ),
                      StatComponent(
                        label: "Abonnements",
                        stat: state.followings.length,
                      ),
                    ],
                  ),
                ),
              ],
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
