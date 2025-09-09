class Validators {
  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  static String? _required(String? value , {String? fieldname}) {
    if (value == null || value.isEmpty) {
      return 'This $fieldname is required';
    }
    return null;
  }

  static String? validateLoginEmail(String? email) {
    final required = _required(email, fieldname: 'email');
    if (required != null) return required;

    if (!_emailRegExp.hasMatch(email!)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validateLoginPassword(String? password) {
    final required = _required(password, fieldname: 'password');
    if (required != null) return required;

    if (password!.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  static String? validateSignupName(String? name) {
    final required = _required(name, fieldname: 'name');
    if (required != null) return required;

    if (name!.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  static String? validateSignupEmail(String? email) {
    final required = _required(email, fieldname: 'email');
    if (required != null) return required;

    if (!_emailRegExp.hasMatch(email!)) {
      return 'Email is not valid';
    }
    return null;
  }

  static String? validateSignupPassword(
    String? password,
    String? confirmPassword,
  ) {
    final required = _required(password, fieldname: 'password');
    if (required != null) return required;

    if (password!.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateResetPassword(String? email) {
    final required = _required(email, fieldname: 'email');
    if (required != null) return required;

    if (!_emailRegExp.hasMatch(email!)) {
      return 'Email is not valid';
    }
    return null;
  }
}
