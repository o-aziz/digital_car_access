import 'package:car_app/services/authentication.service.dart';
import 'package:car_app/views/home.view.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CreateAccountEmail(emailController: _emailController),
                const SizedBox(height: 30.0),
                _CreateAccountPassword(passwordController: _passwordController),
                const SizedBox(height: 30.0),
                submitBtn(context)
              ],
            ),
            Visibility(
              visible: isLoading,
              child: Container(
                height: size.height,
                width: size.width,
                color: Colors.black26,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            )
          ],
        ),
      ),
    );
  }

  ElevatedButton submitBtn(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        AuthenticationHelper()
            .signUp(
                email: _emailController.text,
                password: _passwordController.text)
            .then((result) {
          if (result == null) {
            setState(() {
              isLoading = false;
            });
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeView()));
          } else {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                result,
                style: const TextStyle(fontSize: 16),
              ),
            ));
          }
        });
      },
      child: const Text('Create Account'),
    );
  }
}

class _CreateAccountEmail extends StatelessWidget {
  const _CreateAccountEmail({
    Key? key,
    required this.emailController,
  }) : super(key: key);
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: TextField(
        controller: emailController,
        decoration: const InputDecoration(hintText: 'Email'),
      ),
    );
  }
}

class _CreateAccountPassword extends StatelessWidget {
  const _CreateAccountPassword({
    Key? key,
    required this.passwordController,
  }) : super(key: key);
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: TextField(
        controller: passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: 'Password',
        ),
      ),
    );
  }
}
