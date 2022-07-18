import 'package:flutter/material.dart';
import 'package:med_connect/screens/auth/sign_up_screen.dart';
import 'package:med_connect/screens/home/tab_view.dart';
import 'package:med_connect/screens/shared/custom_buttons.dart';
import 'package:med_connect/screens/shared/custom_text_span.dart';
import 'package:med_connect/screens/shared/custom_textformfield.dart';
import 'package:med_connect/utils/constants.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              children: [
                Hero(
                  tag: kLogoTag,
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: (kScreenWidth(context) - 96) * 0.8,
                  ),
                ),
                const SizedBox(height: 100),
                const CustomTextFormField(
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                const PasswordTextFormField(),
                const SizedBox(height: 50),
                CustomElevatedButton(
                  labelText: 'Login',
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TabView()),
                        (route) => false);
                  },
                ),
                const SizedBox(height: 30),
                CustomTextSpan(
                  firstText: "Don't have an account?",
                  secondText: 'Sign up',
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  children: const [
                    Expanded(child: Divider(height: 40, thickness: 2)),
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('or'),
                    ),
                    Expanded(child: Divider(height: 40, thickness: 2)),
                  ],
                ),
                const SizedBox(height: 30),
                const GoogleButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
