import 'package:flutter/material.dart';
import 'package:list_view/long_list.dart';
import 'package:list_view/long_list_separated.dart';

class SimpleLlist extends StatelessWidget {
  const SimpleLlist({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary,),
      body: ListView(
        children: [
          GestureDetector(child: Text('Elemento 1'), onTap: () {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LongList()),
            );
          }),
          GestureDetector(child: Text('Elemento 2'), onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LongListSeparated()),
            );
          }),
          GestureDetector(child: Text('Elemento 3'), onTap: () {}),
        ],
      ),
    );
  }
}