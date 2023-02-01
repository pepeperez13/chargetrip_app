class Validator {
  static String? validateName({String? name}) {
    if (name == null) {
      return null;
    }
    else if (name.isEmpty) {
      return "Name can\'t be empty";
    }
    return null;
  }

  static String? validateEmail({String? email}) {
    if (email == null) {
      return null;
    }
    else if (email.isEmpty) {
      return "Email can\'t be empty";
    }
    return null;
  }

  static String? validatePassword({String? password}) {
    if (password == null) {
      return null;
    }
    else if (password.isEmpty) {
      return "Password can\'t be empty";
    }
    else if (password.length < 6) {
      return "Enter a password with at least 6 characters";
    }
    return null;
  }
}