import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class AppOverlayLoading extends StatefulWidget {
  final Widget child;
  final bool loading;

  const AppOverlayLoading(
      {super.key, required this.child, required this.loading});

  @override
  State<AppOverlayLoading> createState() => _AppOverlayLoadingState();
}

class _AppOverlayLoadingState extends State<AppOverlayLoading> {
  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: widget.loading,
      color: Colors.black.withAlpha(100),
      progressIndicator:
          const CircularProgressIndicator(color: Colors.white, strokeWidth: 3.0),
      child: widget.child,
    );
  }
}
