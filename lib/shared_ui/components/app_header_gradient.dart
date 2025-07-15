import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/gradients.dart';

class CurvedHeaderBackground extends StatelessWidget {
  const CurvedHeaderBackground({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ClipPath(
        clipper: _CurvedHeaderClipper(),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppGradients.primaryLinearGradient,
          ),
        ),
      ),
    );
  }
}

class _CurvedHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 30,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
