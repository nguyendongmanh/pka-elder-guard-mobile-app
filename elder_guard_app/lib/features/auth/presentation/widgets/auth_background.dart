import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cream,
        gradient: RadialGradient(
          center: Alignment(0, -0.08),
          radius: 1.1,
          colors: [AppColors.creamLight, AppColors.cream, AppColors.creamDeep],
          stops: [0, 0.7, 1],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 230,
              child: CustomPaint(painter: _TopWavesPainter()),
            ),
          ),
          Positioned(
            right: 26,
            bottom: 92,
            child: Opacity(
              opacity: 0.18,
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 44,
                color: Colors.white,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _TopWavesPainter extends CustomPainter {
  const _TopWavesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    _paintLayer(
      canvas,
      size,
      color: AppColors.deepTeal,
      topOffset: 0,
      waveHeight: 26,
    );
    _paintLayer(
      canvas,
      size,
      color: AppColors.tealPrimary.withValues(alpha: 0.94),
      topOffset: 34,
      waveHeight: 30,
    );
    _paintLayer(
      canvas,
      size,
      color: AppColors.tealSecondary.withValues(alpha: 0.78),
      topOffset: 66,
      waveHeight: 22,
    );
  }

  void _paintLayer(
    Canvas canvas,
    Size size, {
    required Color color,
    required double topOffset,
    required double waveHeight,
  }) {
    final path =
        Path()
          ..moveTo(0, 0)
          ..lineTo(0, 66 + topOffset)
          ..cubicTo(
            size.width * 0.10,
            66 + topOffset + waveHeight,
            size.width * 0.24,
            66 + topOffset - waveHeight,
            size.width * 0.38,
            66 + topOffset + 8,
          )
          ..cubicTo(
            size.width * 0.52,
            66 + topOffset + waveHeight,
            size.width * 0.68,
            66 + topOffset - waveHeight,
            size.width * 0.82,
            66 + topOffset + 10,
          )
          ..cubicTo(
            size.width * 0.90,
            66 + topOffset + waveHeight * 0.6,
            size.width * 0.96,
            66 + topOffset - waveHeight * 0.5,
            size.width,
            66 + topOffset,
          )
          ..lineTo(size.width, 0)
          ..close();

    final paint = Paint()..color = color;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
