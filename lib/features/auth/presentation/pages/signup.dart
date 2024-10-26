import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:food_hub/core/assets/app_image.dart';
import 'package:food_hub/features/auth/data/model/signup_model.dart';
import 'package:food_hub/features/auth/domain/usecase/signin_with_google.dart';
import 'package:food_hub/features/auth/domain/usecase/singup_usecase.dart';
import 'package:food_hub/service_locator.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Controllers for name, email, phone, password, and confirm password fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const Text(
                    'Create Your Account',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),

              // Name Input
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  suffixIcon: Icon(
                    CupertinoIcons.person,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Email Input
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  suffixIcon: Icon(
                    CupertinoIcons.mail,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Phone Number Input
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  suffixIcon: Icon(
                    CupertinoIcons.phone,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                keyboardType: TextInputType.phone,
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
                    CupertinoIcons.lock,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Confirm Password Input
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  suffixIcon: Icon(
                    CupertinoIcons.lock,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
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

                    if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      showToast(
                        'Password Doesnt\'t much',
                        backgroundColor: Colors.red,
                        context: context,
                        animation: StyledToastAnimation.slideToTop,
                        reverseAnimation: StyledToastAnimation.fade,
                        position: StyledToastPosition.top,
                        animDuration: const Duration(seconds: 1),
                        duration: const Duration(seconds: 4),
                        curve: Curves.elasticOut,
                        reverseCurve: Curves.linear,
                      );
                      Navigator.pop(context);
                      return;
                    }

                    final result = await sl<SingupUsecase>().call(SignupModel(
                        username: _nameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                        confirmPassword: _confirmPasswordController.text));
                    result.fold((ifLeft) {
                      Navigator.pop(context);
                      showToast(
                        ifLeft,
                        backgroundColor: Colors.red,
                        context: context,
                        animation: StyledToastAnimation.slideToTop,
                        reverseAnimation: StyledToastAnimation.fade,
                        position: StyledToastPosition.top,
                        animDuration: const Duration(seconds: 1),
                        duration: const Duration(seconds: 4),
                        curve: Curves.elasticOut,
                        reverseCurve: Curves.linear,
                      );
                    }, (ifRight) {
                      Navigator.pop(context);
                      context.go('/login');
                      showToast(
                        ifRight,
                        backgroundColor: Colors.green,
                        context: context,
                        animation: StyledToastAnimation.slideToTop,
                        reverseAnimation: StyledToastAnimation.fade,
                        position: StyledToastPosition.top,
                        animDuration: const Duration(seconds: 1),
                        duration: const Duration(seconds: 4),
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
                    'Sign Up',
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
                  'Or Sign Up With',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.secondary),
                    child: GestureDetector(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) => const Center(
                                child: CircularProgressIndicator()),
                          );
                          final result = await sl<SigninWithGoogle>().call();
                          result.fold((ifLeft) {
                            Navigator.pop(context);
                            showToast(
                              ifLeft,
                              backgroundColor: Colors.red,
                              context: context,
                              animation: StyledToastAnimation.slideToTop,
                              reverseAnimation: StyledToastAnimation.fade,
                              position: StyledToastPosition.top,
                              animDuration: const Duration(seconds: 1),
                              duration: const Duration(seconds: 4),
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
                              animDuration: const Duration(seconds: 1),
                              duration: const Duration(seconds: 4),
                              curve: Curves.elasticOut,
                              reverseCurve: Curves.linear,
                            );
                          });
                        },
                        child: Image.asset(height: 50, AppImage.google)),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    context.go('/login'); // Navigate to login page
                  },
                  child: RichText(
                      text: TextSpan(
                          text: 'Already have an Account? ',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary),
                          children: [
                        TextSpan(
                          text: 'Log In',
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
