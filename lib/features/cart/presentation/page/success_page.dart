import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:food_hub/core/assets/app_flare.dart';
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
    Future.delayed(const Duration(seconds: 2)).then((_) {
      context.pushReplacement('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlareActor(
          AppFlare.success,
          animation: 'success',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
