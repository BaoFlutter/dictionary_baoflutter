import 'package:flutter/material.dart';
horizontal_line(context)
{
  return Container(
    height: 1,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.black26
    ),

  );


}

color_line({@required context, @required Color? color})
{
  return Container(
    height: 1,
    width: double.infinity,
    decoration: BoxDecoration(
        color: color
    ),

  );


}


