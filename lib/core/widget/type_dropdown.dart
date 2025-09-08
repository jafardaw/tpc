import 'package:flutter/material.dart';

class TypeDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;

  const TypeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: const InputDecoration(
        labelText: 'النوع',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: const [
        DropdownMenuItem(value: 'real', child: Text('حقيقي')),
        DropdownMenuItem(value: 'estimated', child: Text('تقديري')),
      ],
      onChanged: onChanged,
      validator: validator,
      style: Theme.of(context).textTheme.bodyMedium,
      dropdownColor: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      icon: const Icon(Icons.arrow_drop_down),
      isExpanded: true,
    );
  }
}
