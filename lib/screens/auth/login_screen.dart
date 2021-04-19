import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:kdofavoris/forms/inputs/email_input.dart';
import 'package:kdofavoris/forms/inputs/password_input.dart';
import 'package:kdofavoris/forms/types/auth/form_auth_bloc.dart';
import 'package:kdofavoris/screens/auth/register_screen.dart';
import 'package:kdofavoris/screens/main_screen.dart';
import 'package:kdofavoris/services/authentication/authentication_bloc.dart';
import 'package:kdofavoris/widgets/device_detector_builder.dart';

class LoginScreen extends StatefulWidget {
  static const String ROUTE = "/login";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<FormAuthBloc>().add(FormAuthEmailUnfocused());
      }
    });

    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<FormAuthBloc>().add(FormAuthPasswordUnfocused());
      }
    });
  }

  Widget get _view => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: EmailInput(
              focusNode: _emailFocusNode,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PasswordInput(
              focusNode: _passwordFocusNode,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                if (state is AuthenticationErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          const Text('Vos identifiants ne sont pas corrects.'),
                      duration: const Duration(seconds: 4),
                    ),
                  );
                } else if (state is AuthenticatedState) {
                  context
                      .read<AuthenticationBloc>()
                      .add(AuthenticationInializeEvent());

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    MainScreen.ROUTE,
                    (route) => false,
                  );
                }
              },
              child: BlocBuilder<FormAuthBloc, FormAuthState>(
                buildWhen: (previous, current) =>
                    previous.status != current.status,
                builder: (context, state) => SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  child: ElevatedButton(
                    child: Text("Me connecter".toUpperCase()),
                    onPressed: () {
                      if (state.status.isValidated)
                        context.read<AuthenticationBloc>().add(
                              AuthenticationConnectionEvent(
                                email: state.email.value,
                                password: state.password.value,
                              ),
                            );
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, RegisterScreen.ROUTE),
              child: Text("M'enregistrer"),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: DeviceDetectorBuilder(
            builder: (BuildContext context, DeviceDetectorType device) {
              if (device == DeviceDetectorType.desktop) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: (MediaQuery.of(context).size.width - 480) / 2,
                  ),
                  child: _view,
                );
              }

              return _view;
            },
          ),
        ),
      ),
    );
  }
}
