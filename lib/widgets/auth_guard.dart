import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kdofavoris/screens/auth/login_screen.dart';
import 'package:kdofavoris/services/authentication/authentication_bloc.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is UnauthenticatedState) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(
                context, LoginScreen.ROUTE, (route) => false);
          });

          return SizedBox.shrink();
        }

        return child;
      },
      listener: (context, state) {
        print(state);
        if (state is UnauthenticatedState)
          Navigator.pushNamed(context, LoginScreen.ROUTE);
      },
    );
  }
}