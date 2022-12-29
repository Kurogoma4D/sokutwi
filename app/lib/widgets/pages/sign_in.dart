import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    final string = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(string.signIn)),
      backgroundColor: Colors.white,
      body: Container(),
    );
  }
}
