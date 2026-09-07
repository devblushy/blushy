import 'package:flutter/material.dart';

/// Docsy Avatar: Scalable vector icon of Blushy's expert Docsy matching the brand reference.
/// Renders crisp vector paths for hair, facial features, connected brow/nose, eyes, and smile.
class DocsyAvatar extends StatelessWidget {
  final double size;
  final Color color;
  final Color backgroundColor;
  final bool hasBackground;

  const DocsyAvatar({
    super.key,
    this.size = 32,
    this.color = const Color(0xFFDD0D22),
    this.backgroundColor = Colors.transparent,
    this.hasBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatar = CustomPaint(
      size: Size(size, size),
      painter: DocsyAvatarPainter(
        primaryColor: color,
        faceColor: backgroundColor,
      ),
    );

    if (hasBackground) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: SizedBox(
          width: size * 0.78,
          height: size * 0.78,
          child: avatar,
        ),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: avatar,
    );
  }
}

class DocsyAvatarPainter extends CustomPainter {
  final Color primaryColor;
  final Color faceColor;

  const DocsyAvatarPainter({
    required this.primaryColor,
    this.faceColor = Colors.transparent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    // Maintain 118 / 104 aspect ratio centered within size
    const double targetRatio = 118.0 / 104.0;
    double renderW = size.width;
    double renderH = size.height;
    double offsetX = 0;
    double offsetY = 0;

    if (renderW / renderH > targetRatio) {
      final newW = renderH * targetRatio;
      offsetX = (renderW - newW) / 2;
      renderW = newW;
    } else {
      final newH = renderW / targetRatio;
      offsetY = (renderH - newH) / 2;
      renderH = newH;
    }

    canvas.save();
    canvas.translate(offsetX, offsetY);

    final double w = renderW;
    final double h = renderH;

    // If a non-transparent faceColor is supplied, draw soft background behind face
    if (faceColor != Colors.transparent && faceColor.a > 0) {
      final faceBg = Path();
      faceBg.moveTo(w * 0.36, h * 0.36);
      faceBg.cubicTo(w * 0.30, h * 0.50, w * 0.36, h * 0.82, w * 0.52, h * 0.88);
      faceBg.cubicTo(w * 0.68, h * 0.88, w * 0.74, h * 0.50, w * 0.68, h * 0.36);
      faceBg.close();
      canvas.drawPath(faceBg, Paint()..color = faceColor..style = PaintingStyle.fill);
    }

    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path();
    path.fillType = PathFillType.evenOdd;

    // Subpath 0: Outer voluminous wavy hair and inner face framing
    path.moveTo(w * 0.4873, h * 0.0000);
    path.lineTo(w * 0.4957, h * 0.0094);
    path.lineTo(w * 0.5381, h * 0.0094);
    path.lineTo(w * 0.5465, h * 0.0188);
    path.lineTo(w * 0.5889, h * 0.0377);
    path.lineTo(w * 0.6101, h * 0.0613);
    path.lineTo(w * 0.6101, h * 0.1557);
    path.lineTo(w * 0.5889, h * 0.1887);
    path.lineTo(w * 0.5804, h * 0.1887);
    path.lineTo(w * 0.5550, h * 0.2075);
    path.lineTo(w * 0.5381, h * 0.2075);
    path.lineTo(w * 0.5296, h * 0.2170);
    path.lineTo(w * 0.5126, h * 0.2170);
    path.lineTo(w * 0.5042, h * 0.2264);
    path.lineTo(w * 0.4787, h * 0.2264);
    path.lineTo(w * 0.4703, h * 0.2358);
    path.lineTo(w * 0.4364, h * 0.2358);
    path.lineTo(w * 0.3897, h * 0.2877);
    path.lineTo(w * 0.3897, h * 0.2972);
    path.lineTo(w * 0.3559, h * 0.3443);
    path.lineTo(w * 0.3559, h * 0.3538);
    path.lineTo(w * 0.3474, h * 0.3632);
    path.lineTo(w * 0.3474, h * 0.3821);
    path.lineTo(w * 0.3686, h * 0.3868);
    path.lineTo(w * 0.3770, h * 0.3774);
    path.lineTo(w * 0.4025, h * 0.3774);
    path.lineTo(w * 0.4109, h * 0.3868);
    path.lineTo(w * 0.4533, h * 0.3868);
    path.lineTo(w * 0.4618, h * 0.3962);
    path.lineTo(w * 0.4787, h * 0.3962);
    path.lineTo(w * 0.5169, h * 0.4292);
    path.lineTo(w * 0.5169, h * 0.4387);
    path.lineTo(w * 0.5423, h * 0.4764);
    path.lineTo(w * 0.5423, h * 0.5991);
    path.lineTo(w * 0.5338, h * 0.6085);
    path.lineTo(w * 0.5338, h * 0.6462);
    path.lineTo(w * 0.5381, h * 0.6509);
    path.lineTo(w * 0.5804, h * 0.6509);
    path.lineTo(w * 0.5847, h * 0.6745);
    path.lineTo(w * 0.5804, h * 0.6792);
    path.lineTo(w * 0.5042, h * 0.6792);
    path.lineTo(w * 0.4999, h * 0.6745);
    path.lineTo(w * 0.4999, h * 0.6368);
    path.lineTo(w * 0.5084, h * 0.6274);
    path.lineTo(w * 0.5084, h * 0.6085);
    path.lineTo(w * 0.5169, h * 0.5991);
    path.lineTo(w * 0.5169, h * 0.4858);
    path.lineTo(w * 0.4914, h * 0.4481);
    path.lineTo(w * 0.4914, h * 0.4387);
    path.lineTo(w * 0.4660, h * 0.4198);
    path.lineTo(w * 0.4575, h * 0.4198);
    path.lineTo(w * 0.4152, h * 0.4104);
    path.lineTo(w * 0.3728, h * 0.4340);
    path.lineTo(w * 0.3686, h * 0.4340);
    path.lineTo(w * 0.3643, h * 0.4434);
    path.lineTo(w * 0.3559, h * 0.4434);
    path.lineTo(w * 0.3474, h * 0.4670);
    path.lineTo(w * 0.3474, h * 0.5283);
    path.lineTo(w * 0.3347, h * 0.5660);
    path.lineTo(w * 0.3347, h * 0.5849);
    path.lineTo(w * 0.3474, h * 0.6274);
    path.lineTo(w * 0.3474, h * 0.6415);
    path.lineTo(w * 0.3686, h * 0.6934);
    path.lineTo(w * 0.3686, h * 0.7028);
    path.lineTo(w * 0.3813, h * 0.7264);
    path.lineTo(w * 0.3813, h * 0.7406);
    path.lineTo(w * 0.4279, h * 0.8160);
    path.lineTo(w * 0.4364, h * 0.8160);
    path.lineTo(w * 0.5042, h * 0.8632);
    path.lineTo(w * 0.5296, h * 0.8632);
    path.lineTo(w * 0.5804, h * 0.8255);
    path.lineTo(w * 0.5889, h * 0.8255);
    path.lineTo(w * 0.6059, h * 0.8491);
    path.lineTo(w * 0.6016, h * 0.8538);
    path.lineTo(w * 0.5635, h * 0.8774);
    path.lineTo(w * 0.5592, h * 0.8774);
    path.lineTo(w * 0.5254, h * 0.8915);
    path.lineTo(w * 0.5084, h * 0.8915);
    path.lineTo(w * 0.4660, h * 0.8726);
    path.lineTo(w * 0.4575, h * 0.8726);
    path.lineTo(w * 0.4152, h * 0.8302);
    path.lineTo(w * 0.4067, h * 0.8302);
    path.lineTo(w * 0.3601, h * 0.7453);
    path.lineTo(w * 0.3601, h * 0.7358);
    path.lineTo(w * 0.3474, h * 0.7075);
    path.lineTo(w * 0.3474, h * 0.6840);
    path.lineTo(w * 0.3304, h * 0.6368);
    path.lineTo(w * 0.3304, h * 0.6132);
    path.lineTo(w * 0.3177, h * 0.5755);
    path.lineTo(w * 0.3177, h * 0.5472);
    path.lineTo(w * 0.3220, h * 0.5330);
    path.lineTo(w * 0.3220, h * 0.5094);
    path.lineTo(w * 0.3304, h * 0.4764);
    path.lineTo(w * 0.3304, h * 0.4575);
    path.lineTo(w * 0.3347, h * 0.4481);
    path.lineTo(w * 0.3347, h * 0.4292);
    path.lineTo(w * 0.3177, h * 0.4009);
    path.lineTo(w * 0.3177, h * 0.3868);
    path.lineTo(w * 0.2796, h * 0.3443);
    path.lineTo(w * 0.2753, h * 0.3443);
    path.lineTo(w * 0.2415, h * 0.3208);
    path.lineTo(w * 0.2245, h * 0.3208);
    path.lineTo(w * 0.1779, h * 0.3538);
    path.lineTo(w * 0.1652, h * 0.3538);
    path.lineTo(w * 0.1271, h * 0.4009);
    path.lineTo(w * 0.1228, h * 0.4009);
    path.lineTo(w * 0.0847, h * 0.4670);
    path.lineTo(w * 0.0847, h * 0.4764);
    path.lineTo(w * 0.0508, h * 0.5519);
    path.lineTo(w * 0.0508, h * 0.5849);
    path.lineTo(w * 0.0635, h * 0.6557);
    path.lineTo(w * 0.0635, h * 0.6745);
    path.lineTo(w * 0.0847, h * 0.7075);
    path.lineTo(w * 0.0847, h * 0.7170);
    path.lineTo(w * 0.1228, h * 0.7500);
    path.lineTo(w * 0.1313, h * 0.7500);
    path.lineTo(w * 0.1779, h * 0.7689);
    path.lineTo(w * 0.1991, h * 0.7689);
    path.lineTo(w * 0.2415, h * 0.7594);
    path.lineTo(w * 0.2542, h * 0.7594);
    path.lineTo(w * 0.3008, h * 0.8113);
    path.lineTo(w * 0.3008, h * 0.8208);
    path.lineTo(w * 0.3262, h * 0.8491);
    path.lineTo(w * 0.3262, h * 0.8585);
    path.lineTo(w * 0.3728, h * 0.8962);
    path.lineTo(w * 0.3813, h * 0.8962);
    path.lineTo(w * 0.4279, h * 0.9198);
    path.lineTo(w * 0.4491, h * 0.9198);
    path.lineTo(w * 0.4872, h * 0.9623);
    path.lineTo(w * 0.4915, h * 0.9623);
    path.lineTo(w * 0.5169, h * 0.9764);
    path.lineTo(w * 0.5465, h * 0.9764);
    path.lineTo(w * 0.5847, h * 0.9575);
    path.lineTo(w * 0.6228, h * 0.9151);
    path.lineTo(w * 0.6398, h * 0.9151);
    path.lineTo(w * 0.6864, h * 0.8396);
    path.lineTo(w * 0.6906, h * 0.8396);
    path.lineTo(w * 0.7287, h * 0.7972);
    path.lineTo(w * 0.7415, h * 0.7972);
    path.lineTo(w * 0.7711, h * 0.8160);
    path.lineTo(w * 0.7838, h * 0.8160);
    path.lineTo(w * 0.8304, h * 0.8019);
    path.lineTo(w * 0.8389, h * 0.8019);
    path.lineTo(w * 0.8855, h * 0.7500);
    path.lineTo(w * 0.8898, h * 0.7500);
    path.lineTo(w * 0.9194, h * 0.6792);
    path.lineTo(w * 0.9194, h * 0.6651);
    path.lineTo(w * 0.9321, h * 0.6085);
    path.lineTo(w * 0.9321, h * 0.5708);
    path.lineTo(w * 0.9152, h * 0.5000);
    path.lineTo(w * 0.9152, h * 0.4811);
    path.lineTo(w * 0.8813, h * 0.4198);
    path.lineTo(w * 0.8813, h * 0.4104);
    path.lineTo(w * 0.8389, h * 0.3632);
    path.lineTo(w * 0.8304, h * 0.3632);
    path.lineTo(w * 0.8008, h * 0.3679);
    path.lineTo(w * 0.7881, h * 0.3679);
    path.lineTo(w * 0.7584, h * 0.3443);
    path.lineTo(w * 0.7584, h * 0.3349);
    path.lineTo(w * 0.7415, h * 0.3019);
    path.lineTo(w * 0.7415, h * 0.2877);
    path.lineTo(w * 0.7160, h * 0.2453);
    path.lineTo(w * 0.7160, h * 0.2358);
    path.lineTo(w * 0.6694, h * 0.2075);
    path.lineTo(w * 0.6610, h * 0.2075);
    path.lineTo(w * 0.6313, h * 0.1792);
    path.lineTo(w * 0.6313, h * 0.0519);
    path.lineTo(w * 0.6525, h * 0.0283);
    path.lineTo(w * 0.6906, h * 0.0283);
    path.lineTo(w * 0.7287, h * 0.0472);
    path.lineTo(w * 0.7372, h * 0.0472);
    path.lineTo(w * 0.7711, h * 0.0896);
    path.lineTo(w * 0.7754, h * 0.0896);
    path.lineTo(w * 0.8008, h * 0.1368);
    path.lineTo(w * 0.8008, h * 0.1462);
    path.lineTo(w * 0.8220, h * 0.1981);
    path.lineTo(w * 0.8220, h * 0.2170);
    path.lineTo(w * 0.8432, h * 0.2500);
    path.lineTo(w * 0.8432, h * 0.2594);
    path.lineTo(w * 0.8771, h * 0.3019);
    path.lineTo(w * 0.8855, h * 0.3019);
    path.lineTo(w * 0.9279, h * 0.3160);
    path.lineTo(w * 0.9406, h * 0.3160);
    path.lineTo(w * 0.9830, h * 0.3632);
    path.lineTo(w * 0.9872, h * 0.3632);
    path.lineTo(w * 1.0000, h * 0.4292);
    path.lineTo(w * 1.0000, h * 0.4575);
    path.lineTo(w * 0.9872, h * 0.5283);
    path.lineTo(w * 0.9872, h * 0.5472);
    path.lineTo(w * 0.9703, h * 0.5755);
    path.lineTo(w * 0.9703, h * 0.5896);
    path.lineTo(w * 0.9576, h * 0.6132);
    path.lineTo(w * 0.9576, h * 0.6368);
    path.lineTo(w * 0.9406, h * 0.6698);
    path.lineTo(w * 0.9406, h * 0.6840);
    path.lineTo(w * 0.9237, h * 0.7217);
    path.lineTo(w * 0.9237, h * 0.7453);
    path.lineTo(w * 0.9025, h * 0.7783);
    path.lineTo(w * 0.9025, h * 0.7925);
    path.lineTo(w * 0.8516, h * 0.8443);
    path.lineTo(w * 0.8389, h * 0.8443);
    path.lineTo(w * 0.7838, h * 0.8632);
    path.lineTo(w * 0.7711, h * 0.8632);
    path.lineTo(w * 0.7076, h * 0.8962);
    path.lineTo(w * 0.6991, h * 0.8962);
    path.lineTo(w * 0.6482, h * 0.9670);
    path.lineTo(w * 0.6398, h * 0.9670);
    path.lineTo(w * 0.5974, h * 1.0000);
    path.lineTo(w * 0.5423, h * 1.0000);
    path.lineTo(w * 0.4872, h * 0.9811);
    path.lineTo(w * 0.4787, h * 0.9811);
    path.lineTo(w * 0.4364, h * 0.9481);
    path.lineTo(w * 0.4194, h * 0.9481);
    path.lineTo(w * 0.3643, h * 0.9151);
    path.lineTo(w * 0.3559, h * 0.9151);
    path.lineTo(w * 0.3008, h * 0.8679);
    path.lineTo(w * 0.2838, h * 0.8679);
    path.lineTo(w * 0.2415, h * 0.8160);
    path.lineTo(w * 0.2372, h * 0.8160);
    path.lineTo(w * 0.2033, h * 0.8066);
    path.lineTo(w * 0.1779, h * 0.8066);
    path.lineTo(w * 0.1271, h * 0.7877);
    path.lineTo(w * 0.1101, h * 0.7877);
    path.lineTo(w * 0.0593, h * 0.7358);
    path.lineTo(w * 0.0550, h * 0.7358);
    path.lineTo(w * 0.0211, h * 0.6698);
    path.lineTo(w * 0.0211, h * 0.6509);
    path.lineTo(w * 0.0042, h * 0.5755);
    path.lineTo(w * 0.0042, h * 0.5519);
    path.lineTo(w * 0.0254, h * 0.4670);
    path.lineTo(w * 0.0254, h * 0.4575);
    path.lineTo(w * 0.0550, h * 0.4104);
    path.lineTo(w * 0.0593, h * 0.4104);
    path.lineTo(w * 0.0974, h * 0.3538);
    path.lineTo(w * 0.1016, h * 0.3538);
    path.lineTo(w * 0.1271, h * 0.3160);
    path.lineTo(w * 0.1398, h * 0.3160);
    path.lineTo(w * 0.1779, h * 0.2642);
    path.lineTo(w * 0.1822, h * 0.2642);
    path.lineTo(w * 0.2118, h * 0.2170);
    path.lineTo(w * 0.2118, h * 0.2075);
    path.lineTo(w * 0.2542, h * 0.1557);
    path.lineTo(w * 0.2627, h * 0.1557);
    path.lineTo(w * 0.3008, h * 0.1179);
    path.lineTo(w * 0.3093, h * 0.1179);
    path.lineTo(w * 0.3516, h * 0.0613);
    path.lineTo(w * 0.3516, h * 0.0519);
    path.lineTo(w * 0.3983, h * 0.0189);
    path.lineTo(w * 0.4449, h * 0.0000);
    path.close();

    // Subpath 1: Left eye dot
    path.moveTo(w * 0.4279, h * 0.4858);
    path.lineTo(w * 0.4067, h * 0.4953);
    path.lineTo(w * 0.3940, h * 0.5236);
    path.lineTo(w * 0.4025, h * 0.5472);
    path.lineTo(w * 0.4194, h * 0.5519);
    path.lineTo(w * 0.4406, h * 0.5425);
    path.lineTo(w * 0.4491, h * 0.5142);
    path.lineTo(w * 0.4406, h * 0.4906);
    path.close();

    // Subpath 2: Right eye dot
    path.moveTo(w * 0.6779, h * 0.4858);
    path.lineTo(w * 0.6567, h * 0.4953);
    path.lineTo(w * 0.6482, h * 0.5142);
    path.lineTo(w * 0.6567, h * 0.5425);
    path.lineTo(w * 0.6779, h * 0.5519);
    path.lineTo(w * 0.6991, h * 0.5377);
    path.lineTo(w * 0.7033, h * 0.5189);
    path.lineTo(w * 0.6906, h * 0.4906);
    path.close();

    // Subpath 3: Friendly smile arc
    path.moveTo(w * 0.6567, h * 0.7689);
    path.lineTo(w * 0.6228, h * 0.7877);
    path.lineTo(w * 0.6143, h * 0.7877);
    path.lineTo(w * 0.5677, h * 0.8113);
    path.lineTo(w * 0.5381, h * 0.8113);
    path.lineTo(w * 0.4915, h * 0.7925);
    path.lineTo(w * 0.4788, h * 0.7925);
    path.lineTo(w * 0.4491, h * 0.7689);
    path.lineTo(w * 0.4406, h * 0.7689);
    path.lineTo(w * 0.4576, h * 0.7972);
    path.lineTo(w * 0.4830, h * 0.8160);
    path.lineTo(w * 0.4999, h * 0.8160);
    path.lineTo(w * 0.5423, h * 0.8302);
    path.lineTo(w * 0.5635, h * 0.8302);
    path.lineTo(w * 0.6143, h * 0.8066);
    path.lineTo(w * 0.6271, h * 0.8066);
    path.lineTo(w * 0.6694, h * 0.7736);
    path.close();

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant DocsyAvatarPainter old) {
    return old.primaryColor != primaryColor || old.faceColor != faceColor;
  }
}

/// Docsy Icon: Drop-in scalable vector icon widget
class DocsyIcon extends StatelessWidget {
  final double size;
  final Color? color;
  final Color backgroundColor;

  const DocsyIcon({
    super.key,
    this.size = 24,
    this.color,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    final Color effectiveColor = color ?? iconTheme.color ?? const Color(0xFFDD0D22);

    return DocsyAvatar(
      size: size,
      color: effectiveColor,
      backgroundColor: backgroundColor,
      hasBackground: false,
    );
  }
}

