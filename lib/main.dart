import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Increased from 50ms to 200ms to reduce callback frequency during scroll
  VisibilityDetectorController.instance.updateInterval = const Duration(milliseconds: 200);
  runApp(const PortfolioApp());
}
