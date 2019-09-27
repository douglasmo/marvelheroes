import 'package:flutter/material.dart';
import 'package:marvel/Models/Personagem.dart';

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
      personagens(context, _tela),
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

  Widget personagens(BuildContext context, tela) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.grey,
              height: tela.height * .7,
              child: _containerPersonagens(context),
            ),
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
                          return Container(
                            child: Column(
                              children: <Widget>[
                                Text(perso.name),
                              ],
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
}
