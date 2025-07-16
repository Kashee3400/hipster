import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'base_status.dart';

class MessageBox extends StatelessWidget {
  final String? message;
  final String? imageAsset;
  final double imageSize;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final IconData? icon;
  final bool isLoading;
  final VoidCallback? onRetry;
  final Status type;

  const MessageBox({
    super.key,
    this.message,
    this.imageAsset,
    this.imageSize = 60,
    this.padding,
    this.margin,
    this.borderRadius = 12.0,
    this.icon,
    this.isLoading = false,
    this.onRetry,
    this.type = Status.error,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;
    final typeColors = _getTypeColors(colorScheme);
    final backgroundColor = typeColors.background;
    final textColor = typeColors.foreground;
    final defaultIcon = typeColors.icon;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (imageAsset != null)
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _buildImage(imageAsset!, isWide, imageSize),
          ),
        if (message != null)
          Container(
            padding: padding ?? EdgeInsets.all(12.dg),
            margin: margin ??
                EdgeInsets.symmetric(
                  vertical: 12.h,
                  horizontal: isWide ? 24.w : 12.w,
                ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon ?? defaultIcon, color: textColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isWide ? 16 : 14,
                      color: textColor,
                    ),
                  ),
                ),
                if (onRetry != null)
                  RetryAnimatedIcon(
                    onRetry: onRetry!,
                    isLoading: isLoading,
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildImage(String imageAsset, bool isWide, double imageSize) {
    return Image.asset(
      imageAsset,
      height: isWide ? imageSize * 8 : imageSize * 4,
      fit: BoxFit.contain,
    );
  }

  _MessageTypeColors _getTypeColors(ColorScheme scheme) {
    switch (type) {
      case Status.success:
        return _MessageTypeColors(
          background: scheme.primaryContainer,
          foreground: scheme.onPrimaryContainer,
          icon: Icons.check_circle_outline,
        );
      case Status.info:
        return _MessageTypeColors(
          background: scheme.secondaryContainer,
          foreground: scheme.onSecondaryContainer,
          icon: Icons.info_outline,
        );
      case Status.warning:
        return _MessageTypeColors(
          background: scheme.tertiaryContainer,
          foreground: scheme.onTertiaryContainer,
          icon: Icons.warning_amber_rounded,
        );
      case Status.error:
      default:
        return _MessageTypeColors(
          background: scheme.errorContainer,
          foreground: scheme.onErrorContainer,
          icon: Icons.error_outline,
        );
    }
  }
}

class _MessageTypeColors {
  final Color background;
  final Color foreground;
  final IconData icon;

  _MessageTypeColors({
    required this.background,
    required this.foreground,
    required this.icon,
  });
}

class RetryAnimatedIcon extends StatefulWidget {
  final VoidCallback onRetry;
  final bool isLoading;

  const RetryAnimatedIcon({
    super.key,
    required this.onRetry,
    required this.isLoading,
  });

  @override
  State<RetryAnimatedIcon> createState() => _RetryAnimatedIconState();
}

class _RetryAnimatedIconState extends State<RetryAnimatedIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(); // Start initially if needed

    if (!widget.isLoading) {
      _controller.stop();
    }
  }

  @override
  void didUpdateWidget(RetryAnimatedIcon oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isLoading && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isLoading && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: IconButton(
        onPressed: widget.isLoading ? null : widget.onRetry,
        icon: Icon(Icons.refresh, color: Theme.of(context).colorScheme.onErrorContainer),
      ),
    );
  }
}
