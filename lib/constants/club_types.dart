import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import './palette.dart';

clubs({double? width, double? height, String? points}) => {
  'points': {
    'icon': SvgPicture.asset(
      'assets/icons/PointsIcon.svg',
      width: width ?? 30,
      height: height ?? 30,
    ),
    "promotion_icon": SvgPicture.asset(
      'assets/icons/PointsIcon.svg',
      width: width ?? 30,
      height: height ?? 30,
    ),
    'primary_color': kBlue,
    'middle_widget': Text(points ?? "You earned 32 points")
  },
  'visit': {
    'icon': SvgPicture.asset(
      'assets/icons/VisitIcon.svg',
      width: width ?? 30,
      height: height ?? 30,
    ),
    "promotion_icon": SvgPicture.asset(
      'assets/icons/Circle.svg',
      width: width ?? 30,
      height: height ?? 30,
    ),
    'primary_color': kGreen,
    'middle_widget': Text(points ?? "You visited us 6 times")
  },
};