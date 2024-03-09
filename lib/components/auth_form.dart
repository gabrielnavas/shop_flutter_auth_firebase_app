import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/exceptions/http_exception.dart';
import 'package:shop_flutter_app/models/auth_form_data.dart';
import 'package:shop_flutter_app/providers/auth.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AuthMode _authMode = AuthMode.login;

  AuthFormData authData = AuthFormData.init();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    Widget circularProgress = const Column(
      children: [
        Text(
          'Aguarde!',
          style: TextStyle(
              color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(
          height: 10,
        ),
        CircularProgressIndicator(
          color: Colors.black54,
        )
      ],
    );

    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: _isSignup() ? 405 : 320,
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => AuthFormData.validateEmail(value ?? ''),
                onChanged: (value) => _verifyForm(),
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    authData.email = value;
                  }
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: _passwordController,
                validator: (password) => _isLogin()
                    ? AuthFormData.validatePassword(password ?? '')
                    : AuthFormData.validatePasswords(
                        password ?? '', _passwordConfirmationController.text),
                onChanged: (value) => _verifyForm(),
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    authData.password = value;
                  }
                },
              ),
              if (_isSignup())
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Confirmar senha'),
                  keyboardType: TextInputType.text,
                  controller: _passwordConfirmationController,
                  obscureText: true,
                  validator: (value) => AuthFormData.validatePasswords(
                      value ?? '', _passwordController.text),
                  onChanged: (value) => _verifyForm(),
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      authData.passwordConfirmation = value;
                    }
                  },
                ),
              const SizedBox(
                height: 20,
              ),
              _isLoading
                  ? circularProgress
                  : ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: const Color.fromARGB(142, 18, 77, 178),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8),
                      ),
                      child: Text(
                        _isLogin() ? 'ENTRAR' : 'REGISTRAR',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(179, 255, 255, 255),
                        ),
                      )),
              const Spacer(),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(
                  _isLogin() ? 'DESEJA REGISTRAR?' : 'JÁ POSSUI CONTA?',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(201, 18, 77, 178),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    final bool formIsvalid = _formKey.currentState?.validate() ?? false;
    if (!formIsvalid) {
      return;
    }
    setState(() => _isLoading = true);
    _formKey.currentState?.save();

    final Auth auth = Provider.of<Auth>(context, listen: false);

    if (_isLogin()) {
      auth.autenticate(authData.email, authData.password).then((_) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Autenticado com sucesso!'),
            duration: Duration(seconds: 4),
          ),
        );

        setState(() => _isLoading = false);
      }).onError((error, _) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text((error as HttpException).message),
            duration: const Duration(seconds: 4),
          ),
        );
        setState(() => _isLoading = false);
      });
    } else if (_isSignup()) {
      auth.signup(authData.email, authData.password).then((_) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cadastro feito com sucesso!'),
            duration: Duration(seconds: 4),
          ),
        );
        setState(() => _isLoading = false);
      }).onError((error, _) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text((error as HttpException).message),
            duration: const Duration(seconds: 4),
          ),
        );
        setState(() => _isLoading = false);
      });
    }
  }

  void _switchAuthMode() {
    setState(() {
      if (_authMode == AuthMode.signup) {
        _authMode = AuthMode.login;
      } else {
        _authMode = AuthMode.signup;
      }
    });
  }

  bool _isSignup() => _authMode == AuthMode.signup;
  bool _isLogin() => _authMode == AuthMode.login;

  bool _verifyForm() {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return false;
    }

    _formKey.currentState?.save();
    return true;
  }
}
