import 'package:flutter/material.dart';
import 'package:marvel/Models/Personagem.dart';
import 'package:marvel/Telas/Comics/ComicsTela.dart';

import 'PersonagemController.dart';

class PersonagemTela extends StatefulWidget {
  @override
  _PersonagemTelaState createState() => _PersonagemTelaState();
}

class _PersonagemTelaState extends State<PersonagemTela> {
  ScrollController _scrollController = new ScrollController();
  String assunto = "characters";
  int lenght = 0;
  TextEditingController searchQuery = new TextEditingController(text: "");

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("chamará mais dados");
        mC.getMoreValues(assunto, lenght);
      }
    });

    super.initState();
  }

  Size _tela;
  @override
  Widget build(BuildContext context) {
    _tela = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de personagens"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                  child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchQuery,
                      onChanged: (val) {
                        if (val.length <= 1) {
                          mC.getValues("characters");
                        }
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5),
                          hintText: "Digite nome do heroi"),
                    ),
                  ),
                  RaisedButton(
                      child: Text("Buscar personagens!"),
                      onPressed: () {
                        mC.searchName(searchQuery.text);
                      }),
                ],
              )),
              StreamBuilder(
                stream: mC.outLoad,
                builder: (context, AsyncSnapshot<bool> snapshot) {
                  return snapshot.data
                      ? CircularProgressIndicator()
                      : Container();
                },
              ),
              StreamBuilder<List<Personagem>>(
                  stream: mC.outPerson,
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return Container();
                    }
                    return Expanded(
                      child: ListView.builder(
                          controller: _scrollController,
                          //shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snap.data.length,
                          itemBuilder: (context, int index) {
                            lenght = snap.data.length;
                            Personagem perso = snap.data[index];
                            return ListTile(
                              onTap: () {
                                print("Clicado");
                                print(perso.id);
                                abrirDialog(context, perso);
                              },
                              title: Text(perso.name),
                              leading: CircleAvatar(
                                child: Image.network(perso.thumbnail.path +
                                    "." +
                                    perso.thumbnail.extension),
                              ),
                            );
                          }),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  dialogCarregamento(context) {
    showDialog(
        context: context,
        builder: (context) {
          return CircularProgressIndicator();
        });
  }

  abrirDialog(BuildContext context, Personagem perso) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Container(
              decoration: BoxDecoration(color: Colors.black),
              padding: EdgeInsets.all(_tela.width * .05),
              child: Text(
                perso.name,
                style: TextStyle(color: Colors.white),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: _tela.width / 2,
                    child: Image.network(
                        perso.thumbnail.path + "." + perso.thumbnail.extension),
                  ),
                  Divider(),
                  Text(perso.description.length == 0
                      ? "Sem descrição"
                      : perso.description),
                  Divider(),
                  Text("Comics: ${perso.comics.available}"),
                  Container(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Colors.red,
                      child: Text("Ver comics"),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ComicsTela(perso)));
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
