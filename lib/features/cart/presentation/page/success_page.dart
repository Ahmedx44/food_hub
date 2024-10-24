import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2)).then((_) {
      context.pushReplacement('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: FlareActor(
          'assets/flare/success.flr2d',
          animation: 'success',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
