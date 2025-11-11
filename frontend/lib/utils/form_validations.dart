

class FormValidations {
  static emailValidation(
    String email,
    String? fieldName,
  ) {
    if (email.isEmpty) {
      return requiredFieldValidation(email, fieldName!);
    } else if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return null;
    }
    return 'Please enter valid email id';
  }

  static alternateEmailValidation(String email, String? fieldName) {
    if (email.isEmpty) {
      return requiredFieldValidation(email, fieldName!);
    } else if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return null;
    }
    return 'Alternate email id is required';
  }

  static allowMinimumSpecialCharactersValidator(String input, String text) {
    if (RegExp(r'^[a-zA-Z0-9\.\-_]+$').hasMatch(input)) {
      return null;
    }
    return "Only (.) (-) (_) special characters are allowed";
  }

  static firstNameCharactersValidator(String input, String text) {
    if (RegExp(r'^[a-zA-Z0-9\.\-_ ]+$').hasMatch(input)) {
      if (input.length > 50) {
        return "Characters limit restricted to 30";
      }
      return null;
    }
    return "Enter First Name is required";
  }

  // savita

  static validateAndShowToast(String input, String text, String? fieldName) {
    RegExp specialChars = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    if (input.isEmpty) {
      return text;
    } else {
      if (specialChars.hasMatch(input) && specialChars.hasMatch(input)) {
        return "Only these special characters (.) (-) (_) are allowed";
      } else if (input[0] == "-" || input[0] == "." || input[0] == "_") {
        return "Cannot contain special character before the name";
      } else {
        if (RegExp(r'^[a-zA-Z0-9\.\-_ ]+$').hasMatch(input)) {
          if (input.length > 50) {
            return "${fieldName} Name should be min 1 and max 50";
          }
          return null;
        }
      }
      //return null;
    }

    //  return null;
  }

  static phoneNoValidation(String phoneNo, String? fieldName) {
    if (phoneNo.isEmpty) {
      return requiredFieldValidation(phoneNo, fieldName!);
    } else if (phoneNo.length > 10) {
      return 'Phone Number is not more than 10 digits';
    } else if (RegExp(
            r"(((^[\+,0][9][1])(((\s[0-9]{7,10})|(\S[0-9]{7,10}))|([-]\S[0-9]{7,10})))|((^[\+,0][2]{2,2})((\S[0-9]{7,8})|((([-])[0-9]{7,8})|(\s[0-9]{7,8})))))|(((^[6,7,8,9][0-9]{9,9}))|(^[0,\+](([9][1)|[6,7,8,9]))[0-9]{8,9}))")
        .hasMatch(phoneNo)) {
      return null;
    }
    return 'Please enter valid phone number';
  }

  /// Password Validation
  static passwordValidation(String password, String? fieldName) {
    if (password.isEmpty) {
      return requiredFieldValidation(password, fieldName!);
    }

    return null;
  }

  static CreateAccountpasswordValidation(String password, String? fieldName) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (password.isEmpty) {
      return requiredFieldValidation(password, fieldName!);
    } else if (!regex.hasMatch(password)) {
      return "Password should contain at least one Capital Letter, Small Letters, Numbers & a special character";
    } else if (password.length > 3) {
      return null;
    }
    return 'Please enter valid password';
  }

  static createAccountConfirmPasswordValidation(
      String password, String? fieldName, String cpass) {
    String? passCheck = CreateAccountpasswordValidation(password, fieldName);
    /*  if (passCheck != null) {
      // return CreateAccountpasswordValidation(password, fieldName);
    } else*/
    if (password != cpass) {
      return "Confirm password should be same as New Password";
    }

    return null;
  }

  static requiredFieldValidation(String? value, String fieldName) {
    if (value == null || value.trim() == '') {
      return '$fieldName is required';
    }
    return null;
  }



 

}
