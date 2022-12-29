import 'package:flutter/material.dart';
import 'package:sokutwi/widgets/build_context_ex.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.string.home)),
      body: const Center(
        child: Text('home'),
      ),
    );
  }
}
