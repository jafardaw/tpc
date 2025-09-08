import 'package:flutter/material.dart';

class BirthdayCard extends StatelessWidget {
  const BirthdayCard(
      {super.key,
      required this.tite,
      required this.iconData,
      required this.listColor,
      this.ontap,
      required this.count});
  final String tite;
  final IconData iconData;
  final List<Color> listColor;

  final void Function()? ontap;
  final String count;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: ClipPath(
        clipper: BirthDayCardClipper(),
        child: Container(
          height: 250,
          width: 210,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: listColor,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tite,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 10),
              Icon(
                iconData,
                color: Colors.white,
                size: 40,
              ),
              Text(
                count,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class BirthDayCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    double sideRadius = 30.0;
    double midPoint = size.height * (3 / 5);
    double cornerRadius = 20.0;

    path.moveTo(0, cornerRadius);
    path.lineTo(0, (midPoint - sideRadius));

    // LEFT ARC
    path.quadraticBezierTo(
        sideRadius, midPoint - sideRadius, sideRadius, midPoint);
    path.quadraticBezierTo(
        sideRadius, midPoint + sideRadius, 0, midPoint + sideRadius);

    path.lineTo(0, size.height - cornerRadius);

    // BottomLeft
    path.quadraticBezierTo(0, size.height, cornerRadius, size.height);

    path.lineTo(size.width - cornerRadius, size.height);

    // BottomRight
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - cornerRadius);

    path.lineTo(size.width, (midPoint + sideRadius));

    // RIGHT ARC
    path.quadraticBezierTo((size.width - sideRadius), (midPoint + sideRadius),
        (size.width - sideRadius), (midPoint));
    path.quadraticBezierTo((size.width - sideRadius), (midPoint - sideRadius),
        size.width, midPoint - sideRadius);

    path.lineTo(size.width, cornerRadius);

    // TopRight
    path.quadraticBezierTo(size.width, 0, size.width - cornerRadius, 0);

    path.lineTo(cornerRadius, 0);

    // TopLeft
    path.quadraticBezierTo(0, 0, 0, cornerRadius);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
