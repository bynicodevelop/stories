import 'package:flutter/material.dart';
import 'package:kdofavoris/components/following_profile_component.dart';
import 'package:kdofavoris/components/profile_header_component.dart';
import 'package:kdofavoris/screens/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pushNamed(context, SettingsScreen.ROUTE),
          )
        ],
      ),
      body: Column(
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
      ),
    );
  }
}
