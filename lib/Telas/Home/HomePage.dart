import 'dart:async';

import 'package:flutter/material.dart';
import 'package:marvel/Models/Personagem.dart';
import 'package:marvel/Models/Stories.dart';
import 'package:marvel/Telas/Home/HomeController.dart';
import 'package:marvel/Telas/Personagens/PersonagemTela.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Size _tela;
  Animation animation;
  AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    callAnimation();
    super.initState();
  }

  callAnimation() {
    print("animation called");

    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    _tela = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      drawer: _myDrawer(context),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 1, child: _containerPersonagens(context)),
            Expanded(
              flex: 3,
              child: AnimatedBuilder(
                animation: animationController,
                builder: (context, Widget child) {
                  return Transform(
                    transform: Matrix4.translationValues(
                        animation.value * _tela.width, 0.0, 0.0),
                    child: _stories(context),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _stories(context) {
    return StreamBuilder<List<Stories>>(
        stream: homeC.outStories,
        builder: (context, snap) {
          if (!snap.hasData) {
            return Text("Clique em algum personagem");
          }
          if (snap.connectionState == ConnectionState.waiting) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            );
          }
          return Card(
            elevation: 2.0,
            borderOnForeground: true,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: _tela.width * .05),
                  child: Container(
                    color: Colors.red,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "The 5 first stories",
                        style: TextStyle(
                            fontSize: _tela.width * .05, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Divider(),
                Expanded(
                  child: ListView.builder(
                      itemCount: snap.data.length,
                      itemBuilder: (context, int index) {
                        Stories story = snap.data[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.description,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(story.originalIssue.name),
                          subtitle: Text(story.description.length > 0
                              ? story.description
                              : "Sem descrição"),
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }

  Widget _containerPersonagens(context) {
    return Column(
      children: <Widget>[
        StreamBuilder<List<Personagem>>(
          stream: homeC.outPerson,
          builder: (context, snap) {
            if (!snap.hasData) {
              return Text("Carregando!");
            }
            if (snap.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              return Expanded(
                child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snap.data.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      Personagem perso = snap.data[index];
                      return GestureDetector(
                        onTap: () {
                          homeC.atualizarQuadros(perso);
                          homeC.getStories(perso.id);

                          animationController.repeat();
                          Timer(Duration(seconds: 2), () {
                            animationController.stop();
                          });

                          //callAnimation();
                        },
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              gradient: LinearGradient(colors: [
                                Colors.red,
                                perso.clicked == true ? Colors.blue : Colors.red
                              ], begin: Alignment.topCenter),
                              boxShadow: [
                                BoxShadow(color: Colors.black),
                                BoxShadow(color: Colors.blue)
                              ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: perso.clicked == true
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                  child: Center(
                                      child: Text(
                                    perso.name,
                                    style: TextStyle(
                                        fontSize: _tela.width * .04,
                                        color: perso.clicked == true
                                            ? Colors.white
                                            : Colors.black),
                                  ))),
                              Expanded(
                                child: Image.network(
                                  perso.thumbnail.path +
                                      "." +
                                      perso.thumbnail.extension,
                                  scale: 1.2,
                                ),
                              ),
                              Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: perso.clicked == true
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                  child: Center(
                                      child: Text(
                                    "Comics: ${perso.comics.available.toString()}",
                                    style: TextStyle(
                                        fontSize: _tela.width * .04,
                                        color: perso.clicked == true
                                            ? Colors.white
                                            : Colors.black),
                                  ))),
                            ],
                          ),
                        ),
                      );
                    }),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _myDrawer(context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Menu principal',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.red,
            ),
          ),
          ListTile(
            title: Text('Lista de heróis'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PersonagemTela()));
            },
          ),
        ],
      ),
    );
  }
}
