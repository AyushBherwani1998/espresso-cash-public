import 'package:cryptoplease/ui/background_gradient.dart';
import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

final cpBackgroundGradient = Story(
  name: 'CpBackgroundGradient',
  builder: (context) => const CpBackgroundGradient(
    child: Center(
      child: Text(
        'EspressoCash',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ),
  ),
);