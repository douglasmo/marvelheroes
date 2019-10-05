import 'package:flutter/material.dart';
import 'package:marvel/Models/ComicsNew.dart';
import 'package:marvel/Models/Personagem.dart';
import 'package:marvel/Telas/Comics/ComicsController.dart';

import 'HomeController.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Size _tela;
  TabController tabController;

  @override
  void initState() {
    tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _tela = MediaQuery.of(context).size;

    List<Widget> paginas = [
      _personagens(context, _tela),
      Container(
        color: Colors.green,
      )
    ];

    return Scaffold(
      body: TabBarView(
        controller: tabController,
        children: paginas,
      ),
      bottomNavigationBar: TabBar(controller: tabController, tabs: <Widget>[
        Tab(
          icon: Icon(
            Icons.home,
            color: Colors.black,
          ),
        ),
        Tab(
          icon: Icon(
            Icons.description,
            color: Colors.black,
          ),
        ),
      ]),
    );
  }

  Widget _personagens(BuildContext context, tela) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.grey,
              height: tela.height * .7,
              child: _containerPersonagens(context),
            ),
            _comics(context)
          ],
        ),
      ),
    );
  }

  Widget _containerPersonagens(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: _tela.width * .07),
      child: Column(
        children: <Widget>[
          StreamBuilder<List<Personagem>>(
              stream: homeC.outPerson,
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (!snapshot.hasData) {
                  return Text("Sem dados");
                }
                return Expanded(
                  child: Container(
                    width: double.infinity,
                    child: GridView.builder(
                        itemCount: snapshot.data.length,
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1),
                        itemBuilder: (context, int index) {
                          Personagem perso = snapshot.data[index];
                          return GestureDetector(
                            onTap: () {
                              print(perso.name);
                              homeC.atualizaQuadros(perso);
                              comicsC.getComics(perso.id);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                Colors.red,
                                perso.clicked ? Colors.blue : Colors.red
                              ], begin: Alignment.topCenter)),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    color: perso.clicked
                                        ? Colors.black
                                        : Colors.white,
                                    width: double.infinity,
                                    child: Center(
                                        child: Text(
                                      perso.name,
                                      style: TextStyle(
                                          fontSize: _tela.width * .08,
                                          color: perso.clicked
                                              ? Colors.white
                                              : Colors.black),
                                    )),
                                  ),
                                  Expanded(
                                      child: Container(
                                    child: Image.network(
                                      "${perso.thumbnail.path}.${perso.thumbnail.extension}",
                                      //   fit: BoxFit.,
                                    ),
                                  )),
                                  Container(
                                      //padding: EdgeInsets.all(8),
                                      color: perso.clicked
                                          ? Colors.black
                                          : Colors.white,
                                      child: Center(
                                        child: Text(
                                          "Comics disponíveis: ${perso.comics.available}",
                                          style: TextStyle(
                                              color: perso.clicked
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: _tela.width * .08),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                );
              }),
        ],
      ),
    );
  }

  Widget _comics(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        StreamBuilder<List<ComicsNew>>(
          stream: comicsC.outComics,
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData) {
              return Text("CLique em algum personagem");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
              );
            }
            return Card(
              child: Column(
                children: <Widget>[
                  Container(
                       
                      width: double.infinity,
                      color: Colors.black,
                      child: Center(
                        child: Text(
                          "Comics listas",
                          style: TextStyle(
                              color: Colors.white, fontSize: _tela.width * .05),
                        ),
                      )),
                  Padding(padding: EdgeInsets.only(bottom: _tela.width * .08)),
                  ListView.builder(
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, int index) {
                        ComicsNew comic = snapshot.data[index];
                        return Card(
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: _tela.width * .40,
                                    child: Image.network(
                                        "${comic.thumbnail.path}.${comic.thumbnail.extension}"),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 10)),
                                  Expanded(child: Text(comic.description)),
                                ],
                              ),
                              Divider(),
                            ],
                          ),
                        );
                      })
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
