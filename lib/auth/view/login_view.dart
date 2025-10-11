import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_project/auth/cubit/auth_cubit.dart';
import 'package:translation_project/auth/view/signup_view.dart';
import 'package:translation_project/home/view/home_view.dart';
import 'package:translation_project/l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().loginUser(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.login, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: l10n.email, border: const OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => (value?.isEmpty ?? true) ? l10n.pleaseEnterYourEmail : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: l10n.password, border: const OutlineInputBorder()),
                  obscureText: true,
                  validator: (value) => (value?.isEmpty ?? true) ? l10n.pleaseEnterYourPassword : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(onPressed: _submit, style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)), child: Text(l10n.login)),
                TextButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignupPage())), child: Text(l10n.dontHaveAnAccountSignUp))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
