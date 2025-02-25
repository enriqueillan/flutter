import 'package:flutter/material.dart';

class LongList extends StatelessWidget {

  List<String> listOfItems = List.generate(20, (elemento) => 'Elemnto numero $elemento');

   LongList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text('Long List')
      ),
      body: ListView.builder(
        itemCount: listOfItems.length,
        itemBuilder: (BuildContext context, int index){
          return Text(listOfItems[index]);
        }),
    );
  }
}