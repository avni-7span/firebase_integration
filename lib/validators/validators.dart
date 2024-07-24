class Validators {
  static String? nameValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your name';
      // } else if (!RegExp(r'!@#<>?":_``~;[]\|=-+)(*&^%1234567890')
      //     .hasMatch(value)) {
      //   return 'Please enter valid name';
    } else {
      return null;
    }
  }

  static String? emailValidator(String? value) {
    if (value!.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value)) {
      return 'Enter valid Email';
    } else {
      return null;
    }
  }

  static String? passwordValidator(String? value) {
    if (value!.length < 6) {
      return 'Password must contain least 6 characters!';
    } else {
      return null;
    }
  }

  static String? confirmPasswordValidator({
    required String password,
    required String confirmPassword,
  }) {
    if (confirmPassword.length < 6) {
      return 'Password must contain least 6 characters!';
    } else if (password != confirmPassword) {
      return 'Confirmed passwords must be same as password';
    } else {
      return null;
    }
  }
}
