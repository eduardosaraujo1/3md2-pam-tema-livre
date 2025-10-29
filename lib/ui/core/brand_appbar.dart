import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../config/assets.dart';

AppBar brandAppbar({Widget? title, VoidCallback? onPop}) {
  return AppBar(
    title: title,
    leading: onPop != null
        ? IconButton(icon: Icon(Icons.arrow_back), onPressed: onPop)
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(Assets.logo, width: 48, height: 48),
          ),
  );
}
