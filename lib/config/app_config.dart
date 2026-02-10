import 'dart:ui' show Color;

import 'package:flutter/material.dart';

class AppColors {
  //  Color _mainColor = Color(0xFFFF4E6A);
  // Color _mainColor = Color(0xFFea5c44);
  Color _mainColor = Color(0xFFf46f2c);
  Color _mainDarkColor = Color(0xFFf46f2c);
  Color _secondColor = Color(0xFF344968);
  Color _secondDarkColor = Color(0xFFccccdd);
  Color _accentColor = Color(0xFF8C98A8);
  Color _accentDarkColor = Color(0xFF9999aa);

  Color mainColor(double opacity) {
    return this._mainColor.withOpacity(opacity);
  }

  Color secondColor(double opacity) {
    return this._secondColor.withOpacity(opacity);
  }

  Color accentColor(double opacity) {
    return this._accentColor.withOpacity(opacity);
  }

  Color mainDarkColor(double opacity) {
    return this._mainDarkColor.withOpacity(opacity);
  }

  Color secondDarkColor(double opacity) {
    return this._secondDarkColor.withOpacity(opacity);
  }

  Color accentDarkColor(double opacity) {
    return this._accentDarkColor.withOpacity(opacity);
  }
}
