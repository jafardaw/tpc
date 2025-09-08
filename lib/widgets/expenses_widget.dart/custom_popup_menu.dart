import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPopupMenu extends StatefulWidget {
  final List<String> menuItems;
  final Function(String)? onSelected;
  final String? selectedValue;

  const CustomPopupMenu({
    super.key, 
    required this.menuItems,
    this.onSelected,
    this.selectedValue,
  });

  @override
  State<CustomPopupMenu> createState() => _CustomPopupMenuState();
}

class _CustomPopupMenuState extends State<CustomPopupMenu> {
  String? selectedMenu;

  @override
  void initState() {
    super.initState();
    selectedMenu = widget.selectedValue;
  }

  @override
  void didUpdateWidget(CustomPopupMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue) {
      setState(() {
        selectedMenu = widget.selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        setState(() {
          selectedMenu = value;
        });
        widget.onSelected?.call(value);
      },
      itemBuilder: (BuildContext context) {
        return widget.menuItems.map((String item) {
          return PopupMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: Colors.black, fontSize: 16.sp),
            ),
          );
        }).toList();
      },
      child: PrimaryContainer(
        radius: 10.r,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Text(
                selectedMenu ?? 'Show Menu',
                style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: selectedMenu != null
                        ? Colors.black
                        : const Color(0xFF5E5E5E)),
              ),
              const Spacer(),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF5E5E5E),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final double? radius;
  final Color? color;
  const PrimaryContainer({
    super.key,
    this.radius,
    this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 30),
        boxShadow: [
          BoxShadow(
            color: color ?? Colors.black26,
          ),
           BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color:  Colors.grey[200] ?? Colors.grey,
          ),
        ],
      ),
      child: child,
    );
  }
}
