import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_flutter_app/components/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(63, 185, 212, 0.498),
                  Color.fromRGBO(208, 139, 65, 0.898),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                  // cascade operator
                  transform: Matrix4.rotationZ(-8 * pi / 180)
                    ..translate(-10.00),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.deepOrange.shade900,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black26,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: const Text(
                    'Shop Time',
                    style: TextStyle(
                      fontSize: 45,
                      fontFamily: 'Anton',
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 55,
                ),
                const AuthForm(),
              ],
            ),
          )
        ],
      ),
    );
  }
}


// Exemplo do funcionamento do cascade operator
// void main() {
//   List<int> l = [];
//   l.add(2);
//   l.add(4);
//   l.add(6);
  
//   l.forEach((n) => print(n)); // 2 4 6
  
//   l..add(8)..add(10)..add(12);
//   l.forEach((n) => print(n)); // 2 4 6 8 10 12
// }