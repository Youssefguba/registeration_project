import 'package:flutter/material.dart';

import '../../auth.export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
              Color(0xffE5B2CA),
              Color(0xffCD82DE),
            ],
          ),
        ),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.accountNotFound) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Email not exist!'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (state.status == AuthStatus.loginFailure) {
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

              case AuthStatus.loginSuccess:
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
        Image.asset('assets/images/login.png'),
        const SizedBox(height: 20),
        const Text(
          'Welcome Back!',
          textScaleFactor: 1.3,
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        const Text(
          'Please, Log In.',
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
              controller: _usernameController,
              hint: 'username',
              icon: const Icon(Icons.person_outline_rounded),
            ),
            AuthTextFormField(
              controller: _passwordController,
              hint: 'Password',
              obscureText: true,
              icon: const Icon(Icons.password),
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
          color: const Color(0xff78258B),
          text: 'Continue',
          onPressed: _onLoginPressed,
        ),
        const SizedBox(height: 20),
        const Text(
          '------------ Or ------------',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 20),
        AuthButton(
          color: Colors.white.withOpacity(0.28),
          text: 'Create an Account',
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const SignUpScreen()));
          },
        ),
        const SizedBox(height: 20),

        _loginByGoogleBtn(),
        const SizedBox(height: 20),

      ],
    );
  }

  void _onLoginPressed() {
    final String email = _usernameController.text;
    final String password = _passwordController.text;

    if (_formKey.currentState!.validate()) {
      context
          .read<AuthBloc>()
          .add(LoginEvent(email: email, password: password));
    }
  }

  void _onLoginWithGooglePressed() {
    context.read<AuthBloc>().add(LoginWithGoogle());
  }

  Widget _loginByGoogleBtn() {
    return InkWell(
      onTap: _onLoginWithGooglePressed,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: const Offset(0, 6),
                blurRadius: 10,
                spreadRadius: 1
            )
          ],
        ),
        child: const Center(
          child: Text(
            'Continue with Google',
            textScaleFactor: 1.2,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );

  }
}
