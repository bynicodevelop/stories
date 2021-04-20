import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kdofavoris/services/authentication/authentication_bloc.dart';

class SettingsScreen extends StatelessWidget {
  static const String ROUTE = "/settings";

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            onTap: () => context
                .read<AuthenticationBloc>()
                .add(AuthenticationLogoutEvent()),
            title: Text("Se déconnecter"),
          )
        ],
      ),
    );
  }
}
