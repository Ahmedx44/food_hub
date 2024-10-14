import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:food_hub/features/auth/data/model/reset_model.dart';
import 'package:food_hub/features/auth/domain/usecase/reset_usecase.dart';
import 'package:food_hub/service_locator.dart';
import 'package:go_router/go_router.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Page Title
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Forgot Password',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const Text(
                  'Enter your email to reset password',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            // Email Input
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: const OutlineInputBorder(),
                suffixIcon: Icon(
                  Icons.email,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            // Reset Password Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        const Center(child: CircularProgressIndicator()),
                  );
                  final result = await sl<ResetUsecase>()
                      .call(ResetModel(email: _emailController.text));

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
                    showToast(
                      ifRight,
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
                  'Reset Password',
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            // Back to Login
            Center(
              child: GestureDetector(
                onTap: () {
                  context.go('/login');
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Remember your password? ',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                    children: [
                      TextSpan(
                        text: 'Log In',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
