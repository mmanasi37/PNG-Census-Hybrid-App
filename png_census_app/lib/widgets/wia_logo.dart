import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// WIA Census 2026 shield logo — pure Flutter, no image assets.
class WiaLogo extends StatelessWidget {
  const WiaLogo({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.18,
      child: CustomPaint(
        painter: _ShieldPainter(),
        child: Align(
          alignment: const Alignment(0, -0.15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.home_outlined,
                size: size * 0.34,
                color: AppColors.navyDark,
              ),
              SizedBox(height: size * 0.02),
              Icon(
                Icons.check_rounded,
                size: size * 0.22,
                color: AppColors.navyDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    const r = 10.0;

    final path = Path()
      ..moveTo(r, 0)
      ..lineTo(w - r, 0)
      ..quadraticBezierTo(w, 0, w, r)
      ..lineTo(w, h * 0.52)
      ..quadraticBezierTo(w, h * 0.82, w / 2, h)
      ..quadraticBezierTo(0, h * 0.82, 0, h * 0.52)
      ..lineTo(0, r)
      ..quadraticBezierTo(0, 0, r, 0)
      ..close();

    // Fill — golden yellow
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFFFC300)
        ..style = PaintingStyle.fill,
    );

    // Subtle inner highlight (top half)
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withAlpha(60),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h * 0.5))
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, highlightPaint);

    // Border
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF1C1C1E).withAlpha(40)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
