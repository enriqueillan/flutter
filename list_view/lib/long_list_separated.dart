import 'package:flutter/material.dart';

class LongListSeparated extends StatelessWidget {

  List<String> listOfItems = List.generate(20, (elemento) => 'Elemnto numero $elemento');

   LongListSeparated({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text('Long List Separated')
      ),
      body: ListView.separated(
        itemCount: listOfItems.length,
        itemBuilder: (BuildContext context, int index){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(listOfItems[index]),
                Text('Submenu')
              ]),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        ),
    );
  }
}