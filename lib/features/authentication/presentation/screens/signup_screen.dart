import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth.export.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff9183DE),
              Color(0xffA094E3),
            ],
          ),
        ),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.signupFailure) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Login Failed'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case AuthStatus.initial:
                return _screenBody();
              case AuthStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                );

              case AuthStatus.signupSuccess:
                return Center(
                  child: Text(
                    'Hello, ${state.email}',
                    textScaleFactor: 1.5,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );

              default:
                return _screenBody();
            }
          },
        ),
      ),
    );
  }

  ListView _screenBody() {
    return ListView(
      children: [
        _topWidget(),
        _contentWidget(),
        const SizedBox(height: 20),
        _bottomWidget(),
      ],
    );
  }

  Widget _topWidget() {
    return Column(
      children: [
        Image.asset('assets/images/signup.png'),
        const SizedBox(height: 20),
        const Text(
          'Hi there!',
          textScaleFactor: 1.3,
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        const Text(
          "Let's Get Started",
          textScaleFactor: 1.9,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }

  Widget _contentWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AuthTextFormField(
              controller: _emailController,
              hint: 'Email',
              icon: const Icon(Icons.email),
            ),
            AuthTextFormField(
              controller: _usernameController,
              hint: 'Username',
              icon: const Icon(Icons.person_outline_rounded),
            ),
            AuthTextFormField(
              controller: _phoneController,
              hint: 'Phone Number',
              keyboardType: TextInputType.number,
              icon: const Icon(Icons.phone),
            ),
            AuthTextFormField(
              controller: _passwordController,
              hint: 'Password',
              icon: const Icon(Icons.password),
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomWidget() {
    return Column(
      children: [
        AuthButton(
          color: const Color(0xff52439A),
          text: 'Create an Account',
          onPressed: _onCreateAccountPressed,
        ),
        const SizedBox(height: 20),
        const Text(
          '------------ Or ------------',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 20),
        AuthButton(
          color: Colors.white.withOpacity(0.28),
          text: 'Log In',
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()));
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _onCreateAccountPressed() {
    final String email = _emailController.text;
    final String password = _passwordController.text;
    final String username = _usernameController.text;
    final String phone = _phoneController.text;

    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            SignUpEvent(
              email: email,
              password: password,
              phone: phone,
              username: username,
            ),
          );
    }
  }
}
