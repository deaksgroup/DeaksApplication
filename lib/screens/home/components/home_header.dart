import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback refrsh;
  const HomeHeader({
    Key? key,
    required this.refrsh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SearchField(
      refresh: () => refrsh(),
    );
  }
}
