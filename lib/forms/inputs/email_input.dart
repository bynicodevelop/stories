import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kdofavoris/forms/types/auth/form_auth_bloc.dart';

class EmailInput extends StatelessWidget {
  final FocusNode focusNode;

  const EmailInput({
    Key? key,
    required this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormAuthBloc, FormAuthState>(
      builder: (context, state) => TextField(
        focusNode: focusNode,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onChanged: (value) =>
            context.read<FormAuthBloc>().add(FormAuthEmailChanged(value)),
        decoration: InputDecoration(
          hintText: "Entrez votre email",
          errorText: state.email.invalid
              ? "Assuez-vous d'avoir entré un mail valide."
              : null,
        ),
      ),
    );
  }
}
