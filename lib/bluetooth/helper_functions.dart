import 'package:flutter/material.dart';


void showScaffoldMessage(context,String name){
  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
    backgroundColor: Colors.grey.shade700,
    content: Row(
      children: [
        const Icon(Icons.bluetooth,color: Colors.blue,),
        Text(name,style: const TextStyle(color: Colors.white)),
      ],
    ),
    duration: const Duration(milliseconds: 1700),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(horizontal: 50,vertical: 10),
    behavior: SnackBarBehavior.floating,
  ));
}

void showFailScaffoldMessage(context,String name){
  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
    backgroundColor: Colors.grey.shade700,
    content: Row(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(Icons.bluetooth,color: Colors.red,),
        ),
        Text(name,style: const TextStyle(color: Colors.white)),
      ],
    ),
    duration: const Duration(milliseconds: 1700),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(horizontal: 60,vertical: 20),
    behavior: SnackBarBehavior.floating,
  ));
}