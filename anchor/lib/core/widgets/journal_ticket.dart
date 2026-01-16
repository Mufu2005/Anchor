import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class JournalTicket extends StatelessWidget {
  final Widget child;

  const JournalTicket({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TicketClipper(),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppTheme.deepTaupe, // The card color
        ),
        child: child,
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    double x = 0;
    double y = size.height;
    double increment = 10; // Controls how "jagged" the bottom is

    // The Jagged Bottom (Sawtooth)
    while (x < size.width) {
      x += increment;
      y = (y == size.height) ? size.height - 10 : size.height;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, 0.0);

    // The Side "Notches" (Optional - remove if you just want jagged bottom)
    path.addOval(Rect.fromCircle(center: Offset(0, size.height / 2), radius: 10));
    path.addOval(Rect.fromCircle(center: Offset(size.width, size.height / 2), radius: 10));
    path.fillType = PathFillType.evenOdd;

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}