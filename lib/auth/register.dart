import 'package:bookloop/auth/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/auth_text_field.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController name = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool usernameExists = false;
  Future<bool> checkDocumentExists(
      String collectionName, String documentId) async {
    final docRef =
        FirebaseFirestore.instance.collection(collectionName).doc(documentId);

    return await docRef.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        setState(() {
          usernameExists = true;
        });
        // username.clear();
        return true;
      } else {
        setState(() {
          usernameExists = false;
        });
        return false;
      }
    });
  }

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
                'Register',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: name,
              keyboard: TextInputType.name,
              label: 'Full Name',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: CustomTextField(
                controller: username,
                keyboard: TextInputType.text,
                label: 'Username',
                onSaved: (value) async {
                  await checkDocumentExists('users', username.text);
                },
                trailing: Icon(
                  !usernameExists ? Icons.done : Icons.close,
                  color: !usernameExists ? Colors.green : Colors.red,
                ),
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
                  if (!(await checkDocumentExists('users', username.text))) {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email.text, password: password.text);
                    if (FirebaseAuth.instance.currentUser != null) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(username.text)
                          .set({'name': name.text, 'email': email.text});
                    }
                  }
                },
                child: const Text('Register')),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Have an account?'),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignIn()));
                    },
                    child: const Text('Sign In'))
              ],
            )
          ],
        )),
      ),
    );
  }
}
