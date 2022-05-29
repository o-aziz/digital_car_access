import 'package:car_app/services/authentication.service.dart';
import 'package:car_app/views/home.view.dart';
import 'package:car_app/views/sign_up.view.dart';
import 'package:flutter/material.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LoginEmail(emailController: _emailController),
                const SizedBox(height: 30.0),
                _LoginPassword(passwordController: _passwordController),
                const SizedBox(height: 30.0),
                submitBtn(context),
                const SizedBox(height: 30.0),
                const _CreateAccountButton(),
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
            .signIn(
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
      child: const Text('Login'),
    );
  }
}

class _LoginEmail extends StatelessWidget {
  const _LoginEmail({
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

class _LoginPassword extends StatelessWidget {
  const _LoginPassword({
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

class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SignUpView(),
          ),
        );
      },
      child: const Text('Create Account'),
    );
  }
}
