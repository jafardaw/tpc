String? validateRequiredNumber(String? value, {required String fieldName}) {
  if (value == null || value.isEmpty) {
    return 'الرجاء إدخال $fieldName';
  }
  if (double.tryParse(value) == null) {
    return 'الرجاء إدخال رقم صحيح لـ $fieldName';
  }
  return null;
}
