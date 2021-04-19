import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:kdofavoris/forms/inputs/email_input.dart';
import 'package:kdofavoris/forms/inputs/password_input.dart';
import 'package:kdofavoris/forms/types/auth/form_auth_bloc.dart';
import 'package:kdofavoris/screens/auth/login_screen.dart';
import 'package:kdofavoris/screens/main_screen.dart';
import 'package:kdofavoris/services/authentication/authentication_bloc.dart';
import 'package:kdofavoris/widgets/device_detector_builder.dart';

class RegisterScreen extends StatefulWidget {
  static const String ROUTE = "/register";

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                  if (state.authenticationErrorType ==
                      AuthenticationErrorType.emailAlreadyExists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            'Vous ne pouvez créer de compte avec cet email'),
                        duration: const Duration(seconds: 4),
                        action: SnackBarAction(
                          label: "Me connecter".toUpperCase(),
                          onPressed: () =>
                              Navigator.pushNamed(context, LoginScreen.ROUTE),
                        ),
                      ),
                    );
                  }
                } else if (state is AuthenticatedState) {
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
                    child: Text("M'enregistrer".toUpperCase()),
                    onPressed: () {
                      if (state.status.isValidated)
                        context.read<AuthenticationBloc>().add(
                              AuthenticationRegisterEvent(
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
              onTap: () => Navigator.pushNamed(context, LoginScreen.ROUTE),
              child: Text("Me connecter"),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: DeviceDetectorBuilder(
            builder: (BuildContext context, DeviceDetectorType device) {
              print(device);

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
