import 'package:flutter/material.dart';
import 'package:shop_flutter_app/components/center_message.dart';

class CircularProgressMessage extends StatelessWidget {
  final String message;
  final Function() onRefresh;
  const CircularProgressMessage(this.message, this.onRefresh, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          child: CenterMessage(message, onRefresh),
        ),
        const CircularProgressIndicator(),
      ],
    );
  }
}
