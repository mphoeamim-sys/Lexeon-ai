import 'dart:ui';
import 'package:flutter/material.dart';

class LiquidGlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const LiquidGlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 28.0,
    this.blur = 25.0,
    this.borderColor,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.12),
                  Colors.white.withOpacity(0.03),
                  const Color(0xFF1E3A8A).withOpacity(0.08),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
              border: Border.all(
                color: borderColor ?? Colors.white.withOpacity(0.25),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: -2,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: const Color(0xFF1E3A8A).withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: -5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}