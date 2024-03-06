import 'package:flutter/material.dart';

class CenterMessage extends StatelessWidget {
  final String message;
  final Function() onRefresh;
  const CenterMessage(this.message, this.onRefresh, {super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh,
      child: Stack(
        children: [
          ListView(), // to work RefreshIndicator, dont remove this
          Center(
            child: Text(
              message,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
                color: Colors.black54,
              ),
            ),
          )
        ],
      ),
    );
  }
}
