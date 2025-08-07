import 'package:flutter/material.dart';

PreferredSizeWidget buildAppBar() {
  return AppBar(
    title: const Text('Home'),
    centerTitle: true,
    elevation: 0,
    actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () {})],
  );
}
