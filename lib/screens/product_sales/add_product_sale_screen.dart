import 'package:flutter/material.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/widgets/expenses_widget.dart/custom_popup_menu.dart';

class AddProductSaleScreen extends StatelessWidget {
  const AddProductSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading:
              true, // Set to false if this is a root page
          title: 'Add Product Sales ',
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 50),
          CustomPopupMenu(menuItems: []),
        ],
      ),
    );
  }
}
