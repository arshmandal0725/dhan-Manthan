import 'package:flutter/material.dart';

class Constants {
  final BuildContext context;

  const Constants({required this.context});

  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
}
