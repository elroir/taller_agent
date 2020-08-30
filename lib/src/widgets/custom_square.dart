import 'package:flutter/material.dart';

class CustomSquare extends StatelessWidget {

  final double height;

  CustomSquare({this.height});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      color: Colors.red,
      width:size.width ,
      height: (height!=null) ? height : size.height*0.28,
    );

  }
}
