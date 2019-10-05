import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:marvel/Models/Personagem.dart';
import 'package:marvel/Telas/Helper.dart';
import 'package:rxdart/rxdart.dart';

class HomeController extends BlocBase {
  //BLOC PERSONAGEM
  BehaviorSubject<List<Personagem>> blocPersoagem = new BehaviorSubject();
  Sink<List<Personagem>> get inPerson => blocPersoagem.sink;
  Stream<List<Personagem>> get outPerson => blocPersoagem.stream;
  //FIM BLOC PERSONAGEM

  List<Personagem> listaPersonagem;
  Personagem personagem;

  HomeController() {
    escolhePersonagem([1009351, 1009220, 1009610]);
  }

  escolhePersonagem(List<int> ids) {
    listaPersonagem = new List();

    for (var id in ids) {
      getPersonagemPorId(id);
    }
  }

  getPersonagemPorId(int id) {
    String urlFinal = gerarUrl("characters/$id");
    print(urlFinal);
    http.get(urlFinal).then((v) {
      var personagems = jsonDecode(v.body)["data"]["results"];
      for (var personagemTemp in personagems) {
        personagem = Personagem.fromJson(personagemTemp);
        listaPersonagem.add(personagem);

        inPerson.add(listaPersonagem);
      }
    });
  }

  atualizaQuadros(Personagem perso) {
    for (var a in listaPersonagem) {
      a.clicked = false;
    }
    perso.clicked = true;
    inPerson.add(listaPersonagem);
  }

  @override
  void dispose() {
    blocPersoagem.close();
  }
}

HomeController homeC = new HomeController();
