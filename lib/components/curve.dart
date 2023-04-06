import 'package:flutter/material.dart';
import 'package:chat_api_app/components/app_theme.dart';

class ImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
    // var path = Path();
    // path.lineTo(
    //   0,
    //   size.height - 70,
    // );
    // path.quadraticBezierTo(
    //   0,
    //   size.height + 40,
    //   size.width - 40,
    //   size.height - 130,
    // );
    // path.quadraticBezierTo(
    //   size.width + 60,
    //   size.height - 170,
    //   size.width,
    //   0,
    // );
    // path.close();
    // return path;
  }

  Path getClipBak(Size size) {
    var path = Path();

    path.lineTo(0, size.height * 0.30);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.36,
      size.width * 0.70,
      size.height * 0.30,
    );
    path.lineTo(size.width, size.height * 0.25);

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = AppTheme.kSpiritedGreen;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.70);

    path.quadraticBezierTo(
      size.width * 0.40,
      size.height * 0.80,
      size.width * 0.75,
      size.height * 0.60,
    );
    path.quadraticBezierTo(
      size.width * 0.95,
      size.height * 0.48,
      size.width,
      size.height * 0.32,
    );

    path.lineTo(size.width, 20);
    path.quadraticBezierTo(size.width, 0, size.width - 20, 0);
    path.lineTo(20, 0);
    path.quadraticBezierTo(0, 0, 0, 20);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CurvePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CurvePainter oldDelegate) => false;
}

// class CurvePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     var paint = Paint();
//     paint.color = Colors.green;
//     paint.style = PaintingStyle.fill;

//     var path = Path();

//     path.moveTo(0, size.height * 0.30);

//     path.quadraticBezierTo(
//       size.width * 0.25,
//       size.height * 0.36,
//       size.width * 0.70,
//       size.height * 0.30,
//     );
//     path.lineTo(size.width, size.height * 0.25);

//     path.lineTo(size.width, 0);
//     path.lineTo(0, 0);

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CurvePainter oldDelegate) => false;

//   @override
//   bool shouldRebuildSemantics(CurvePainter oldDelegate) => false;
// }

    // path.lineTo(size.width, size.height * 0.10);
    // path.quadraticBezierTo(
    //   size.width,
    //   0,
    //   size.width * 0.90,
    //   0,
    // );
    // path.lineTo(size.width * 0.10, 0);
    // path.quadraticBezierTo(
    //   0,
    //   0,
    //   0,
    //   size.height * 0.10,
    // );