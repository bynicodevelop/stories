import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kdofavoris/forms/types/auth/form_auth_bloc.dart';

class PasswordInput extends StatefulWidget {
  final FocusNode focusNode;

  const PasswordInput({
    Key? key,
    required this.focusNode,
  }) : super(key: key);

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormAuthBloc, FormAuthState>(
      builder: (context, state) => TextField(
        focusNode: widget.focusNode,
        obscureText: !showPassword ? true : false,
        textInputAction: TextInputAction.next,
        onChanged: (value) =>
            context.read<FormAuthBloc>().add(FormAuthPasswordChanged(value)),
        decoration: InputDecoration(
          hintText: "Entrez votre mot de passe",
          errorText: state.password.invalid
              ? "Assuez-vous d'avoir entré un mot de passe valide."
              : null,
          suffixIcon: InkWell(
            onTap: () => setState(() => showPassword = !showPassword),
            child:
                Icon(!showPassword ? Icons.visibility : Icons.visibility_off),
          ),
        ),
      ),
    );
  }
}
