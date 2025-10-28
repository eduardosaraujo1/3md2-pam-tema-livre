import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/assets.dart';

class LoginDecorator extends StatelessWidget {
  const LoginDecorator({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;

          return SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _Decorator(height: height * 0.4),
                SafeArea(child: child),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Decorator extends StatelessWidget {
  const _Decorator({this.height = 400});

  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          // Custom shaped background
          CustomPaint(
            size: Size(double.infinity, height),
            painter: _DecoratorPainter(
              fillColor: theme.colorScheme.primary,
              strokeColor: theme.colorScheme.onSurface,
            ),
          ),
          // Logo centered
          Center(child: SvgPicture.asset(Assets.logo, width: 256, height: 256)),
        ],
      ),
    );
  }
}

class _DecoratorPainter extends CustomPainter {
  final Color fillColor;
  final Color strokeColor;

  _DecoratorPainter({required this.fillColor, required this.strokeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path();

    // Scale the SVG path to fit the available width
    final scaleX = size.width / 412;
    final scaleY = size.height / 401;

    // Start path based on SVG: M112.009 359.983C59.4137 359.983 37.5 397.64 0 397.64V0H412V361.897C412 374.598 394.078 400 322.392 400C232.785 400 177.754 359.983 112.009 359.983Z
    path.moveTo(112.009 * scaleX, 359.983 * scaleY);

    // Cubic bezier curve
    path.cubicTo(
      59.4137 * scaleX,
      359.983 * scaleY,
      37.5 * scaleX,
      397.64 * scaleY,
      0,
      397.64 * scaleY,
    );

    // Line to top left
    path.lineTo(0, 0);

    // Line to top right
    path.lineTo(size.width, 0);

    // Line down to start of curve
    path.lineTo(size.width, 361.897 * scaleY);

    // Cubic bezier curve on right side
    path.cubicTo(
      size.width,
      374.598 * scaleY,
      394.078 * scaleX,
      400 * scaleY,
      322.392 * scaleX,
      400 * scaleY,
    );

    // Cubic bezier curve at bottom
    path.cubicTo(
      232.785 * scaleX,
      400 * scaleY,
      177.754 * scaleX,
      359.983 * scaleY,
      112.009 * scaleX,
      359.983 * scaleY,
    );

    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
