class Validate {
  static passwordValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "password missing";
    }
    if (value.trim().length < 8) {
      return "password too short";
    }
    return null;
  }

  static emailValidate(value) {
    if (value == null || value.trim().isEmpty) {
      return "email required";
    }
    int index = 0;
    for (int i = 0; i < value.length; i++) {
      if (value[i] == '@') {
        index = i;
        break;
      }
    }
    String email = value.substring(0, index);
    if (int.tryParse(email) != null ||
        double.tryParse(email) != null ||
        email.length < 5) {
      return "invalid email";
    }
    return null;
  }

  static String? validateNotes(String? value) {
    if (value == null || value.isEmpty) {
      return 'please enter notes';
    }

    if (value.length < 3) {
      return 'notes must be at least 3 characters';
    }

    if (value.length > 500) {
      return 'notes is too long';
    }

    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'please enter description';
    }

    if (value.length < 3) {
      return 'description must be at least 3 characters';
    }

    if (value.length > 500) {
      return 'description is too long';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'please enter name';
    }

    if (value.length < 3) {
      return 'name must be at least 3 characters';
    }

    if (value.length > 500) {
      return 'name is too long';
    }

    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'please enter amount';
    }

    // Check if it's a valid number
    if (double.tryParse(value) == null) {
      return 'please enter valid amount';
    }

    // Check if amount is positive
    double amount = double.parse(value);
    if (amount <= 0) {
      return 'amount must be greater than 0';
    }

    // Check if amount is reasonable (less than 1 million)
    if (amount > 1000000) {
      return 'amount is too large';
    }

    return null;
  }

  static String? validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال السنة';
    }

    final year = int.tryParse(value);
    if (year == null) {
      return 'الرجاء إدخال أرقام فقط';
    }

    final currentYear = DateTime.now().year;
    if (year < 2000 || year > currentYear) {
      return 'الرجاء إدخال سنة بين 2000 و $currentYear';
    }
    return null;
  }

  static String? validateMonth(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال الشهر';
    }

    final month = int.tryParse(value);
    if (month == null) {
      return 'الرجاء إدخال أرقام فقط';
    }

    if (month < 1 || month > 12) {
      return 'الرجاء إدخال شهر بين 1 و 12';
    }

    return null;
  }
  static String? validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'please select category';
    }
    return null;
  }

 static String? validateType(String? value) {
    if (value == null || value.isEmpty) {
      return 'please select type';
    }
    return null;
  }

}
