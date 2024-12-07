import 'package:bookloop/auth/register.dart';
import 'package:bookloop/homepage.dart';
import 'package:bookloop/widgets/auth_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SizedBox.expand(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'Sign In',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            CustomTextField(
              controller: email,
              keyboard: TextInputType.emailAddress,
              label: 'email',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: CustomTextField(
                controller: password,
                keyboard: TextInputType.visiblePassword,
                isObscured: true,
                label: 'password',
                isLast: true,
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.maxFinite, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                onPressed: () async {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email.text, password: password.text);
                  if (FirebaseAuth.instance.currentUser != null &&
                      context.mounted) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  }
                },
                child: const Text('Sign In')),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account?'),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()));
                    },
                    child: const Text('Register'))
              ],
            )
          ],
        )),
      ),
    );
  }
}
