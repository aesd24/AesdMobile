//import 'package:aesd_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class AuthOverlayLoading extends StatefulWidget {
  final Widget child;
  final bool loading;

  const AuthOverlayLoading(
      {super.key, required this.child, required this.loading});

  @override
  State<AuthOverlayLoading> createState() => _AuthOverlayLoadingState();
}

class _AuthOverlayLoadingState extends State<AuthOverlayLoading> {
  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: widget.loading,
      color: Colors.black.withOpacity(0.4),
      child: widget.child,
    );
  }
}
