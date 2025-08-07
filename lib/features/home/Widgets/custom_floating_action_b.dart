import 'package:flutter/material.dart';

Widget buildFloatingActionButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(right: 24, left: 16),
    child: SizedBox(
      width: 112,
      height: 56,
      child: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to add transaction screen
          // Navigator.pushNamed(context, '/add-transaction');
        },
        icon: const Icon(Icons.add, size: 24),
        label: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            'Add',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
    ),
  );
}
