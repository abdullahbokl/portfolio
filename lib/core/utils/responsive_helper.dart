import 'package:flutter/material.dart';

import '../constants/app_breakpoints.dart';

/// Responsive layout builder that switches between mobile, tablet, and desktop.
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    required this.mobile,
    this.tablet,
    this.desktop,
    super.key,
  });

  final Widget Function(BuildContext context, BoxConstraints constraints) mobile;
  final Widget Function(BuildContext context, BoxConstraints constraints)?
      tablet;
  final Widget Function(BuildContext context, BoxConstraints constraints)?
      desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = MediaQuery.sizeOf(context).width;

        if (width >= AppBreakpoints.tablet) {
          return (desktop ?? tablet ?? mobile)(context, constraints);
        }
        if (width >= AppBreakpoints.mobile) {
          return (tablet ?? mobile)(context, constraints);
        }
        return mobile(context, constraints);
      },
    );
  }
}

