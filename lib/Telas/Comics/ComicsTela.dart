import 'package:flutter/material.dart';
import 'package:marvel/Models/Comics.dart';
import 'package:marvel/Models/Personagem.dart';

class ComicsTela extends StatefulWidget {
  Personagem perso;

  ComicsTela(this.perso);

  @override
  _ComicsTelaState createState() => _ComicsTelaState();
}

class _ComicsTelaState extends State<ComicsTela> {
  Personagem perso;

  @override
  void initState() {
    perso = widget.perso;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(perso.name),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: perso.comics.items.length,
                itemBuilder: (context, int index) {
                  Comics comics = perso.comics;
                  print(comics.items[index].resourceURI);
                  return ListTile(
                    title: Text(comics.items[index].name),
                    leading: CircleAvatar(
                      child: Icon(Icons.filter),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
