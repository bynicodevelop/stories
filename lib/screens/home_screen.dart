import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kdofavoris/components/following_profile_component.dart';
import 'package:kdofavoris/components/profile_header_component.dart';
import 'package:kdofavoris/services/authentication/authentication_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    context.read<AuthenticationBloc>().add(AuthenticationInializeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: SizedBox.shrink(),
        ),
        ProfileHeaderComponent(),
        Expanded(
          flex: 4,
          child: FollowingProfileComponent(),
        ),
        Expanded(
          flex: 1,
          child: SizedBox.shrink(),
        ),
      ],
    );
  }
}
