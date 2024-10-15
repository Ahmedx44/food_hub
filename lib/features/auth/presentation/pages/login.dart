import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:food_hub/core/assets/app_image.dart';
import 'package:food_hub/features/auth/data/model/sigin_model.dart';
import 'package:food_hub/features/auth/domain/usecase/sigin_usecase.dart';
import 'package:food_hub/service_locator.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers for email and password fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Text(
                    'Log In',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const Text(
                    'To Your Account',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),

              // Email Input
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  suffixIcon: Icon(
                    Icons.email,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Password Input
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  suffixIcon: Icon(
                    Icons.lock,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.go('/forgetpassword');
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    final result = await sl<SiginUsecase>().call(SigninModel(
                      email: _emailController.text,
                      password: _passwordController.text,
                    ));
                    result.fold((ifLeft) {
                      Navigator.pop(context);
                      showToast(
                        ifLeft,
                        backgroundColor: Colors.red,
                        context: context,
                        animation: StyledToastAnimation.slideToTop,
                        reverseAnimation: StyledToastAnimation.fade,
                        position: StyledToastPosition.top,
                        animDuration: Duration(seconds: 1),
                        duration: Duration(seconds: 4),
                        curve: Curves.elasticOut,
                        reverseCurve: Curves.linear,
                      );
                    }, (ifRight) {
                      Navigator.pop(context);
                      context.go('/home');
                      showToast(
                        ifRight,
                        backgroundColor: Colors.green,
                        context: context,
                        animation: StyledToastAnimation.slideToTop,
                        reverseAnimation: StyledToastAnimation.fade,
                        position: StyledToastPosition.top,
                        animDuration: Duration(seconds: 1),
                        duration: Duration(seconds: 4),
                        curve: Curves.elasticOut,
                        reverseCurve: Curves.linear,
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 80.0,
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),

              const Center(
                child: Text(
                  'Or Login With',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.secondary),
                      padding: const EdgeInsets.all(5),
                      child: Image.asset(height: 50, AppImage.apple)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.secondary),
                      child: Image.asset(height: 50, AppImage.google)),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    context.go('/signup');
                  },
                  child: RichText(
                      text: TextSpan(
                          text: 'Dont have an Account?',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                          children: [
                        TextSpan(
                          text: 'Singup',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ])),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
