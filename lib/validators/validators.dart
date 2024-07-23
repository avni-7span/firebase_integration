class Validators {
  static String? emailValidator(String? value) {
    if (value!.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value!)) {
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
}
