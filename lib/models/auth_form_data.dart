class AuthFormData {
  String email;
  String password;
  String passwordConfirmation;

  AuthFormData({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  static init() {
    return AuthFormData(
      email: '',
      password: '',
      passwordConfirmation: '',
    );
  }

  static String? validateEmail(String email) {
    if (!email.contains("@")) {
      return "E-mail inválido";
    }
    if (email.length < 6) {
      return "E-mail inválido";
    }
    if (email.length > 40) {
      return "E-mail deve ter no mínimo 40 caracteres";
    }

    return null;
  }

  static String? validatePassword(String password) {
    if (password.length < 6) {
      return 'Senha deve ter no mínimo 6 caracteres';
    }
    if (password.length > 100) {
      return 'Senha deve ter no máximo 6 caracteres';
    }
    return null;
  }

  static String? validatePasswords(String password1, String password2) {
    String? pass1 = validatePassword(password1);
    if (pass1 != null) {
      return pass1;
    }
    String? pass2 = validatePassword(password1);
    if (pass2 != null) {
      return pass2;
    }
    if (password1 != password2) {
      return 'Senhas estão diferentes.';
    }
    return null;
  }
}
