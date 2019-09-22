import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:marvel/Models/Personagem.dart';
import 'package:marvel/Models/Stories.dart';
import 'package:rxdart/subjects.dart';

import '../Helper.dart';

class HomeController extends BlocBase {
  var timeStamp = DateTime.now();
  var hash;
  var url = "http://gateway.marvel.com/v1/public/";

  //Bloc personagem
  BehaviorSubject<List<Personagem>> charBloc =
      new BehaviorSubject<List<Personagem>>();
  Sink<List<Personagem>> get inPerson => charBloc.sink;
  Stream<List<Personagem>> get outPerson => charBloc.stream;
  Personagem personagem;
  List<Personagem> lista;
  //Bloc personagem

  //Bloc STORIES
  BehaviorSubject<List<Stories>> stoBloc = new BehaviorSubject<List<Stories>>();
  Sink<List<Stories>> get inStories => stoBloc.sink;
  Stream<List<Stories>> get outStories => stoBloc.stream;
  Stories storie;
  List<Stories> listaStories;
  //Bloc personagem

  HomeController() {
    escolhePersonagem([1009351, 1009220, 1009610]);
  }

  getStories(int persoId) {
    listaStories = new List();

    inStories.add(null);
    // "/v1/public/characters/{characterId}/stories"
    String urlFinal =
        gerarUrl("characters/$persoId/stories", adicional: "&limit=5");

    http.get(urlFinal).then((v) {
      var storieTemp = jsonDecode(v.body)["data"]["results"];
      for (var a in storieTemp) {
        storie = new Stories.fromJson(a);
        listaStories.add(storie);
        inStories.add(listaStories);
      }
      print(listaStories);
    });
  }

  escolhePersonagem(List<int> ids) {
    lista = new List();

    for (var a in ids) {
      getPersonagemPorId("characters", a);
    }
  }

  getPersonagemPorId(String assunto, int id) {
    String urlFinal = gerarUrl("characters/$id");

    http.get(urlFinal).then((v) {
      var personagens = jsonDecode(v.body)["data"]["results"];
      for (var a in personagens) {
        personagem = new Personagem.fromJson(a);
        lista.add(personagem);
        inPerson.add(lista);
      }
      print(lista);
    });
  }

  atualizarQuadros(Personagem perso) {
    for (var a in lista) {
      a.clicked = false;
    }
    perso.clicked = perso.clicked == true ? false : true;

    print("adicionando lista");
    inPerson.add(lista);
  }

  String gerarUrl(String assunto, {String adicional = ""}) {
    gerarHash();
    String urlFinal =
        "$url$assunto?apikey=${Helper.publicApiKey}&hash=$hash&ts=${timeStamp.toIso8601String()}$adicional";
    print(urlFinal);
    return urlFinal;
  }

  gerarHash() {
    hash = generateMd5(timeStamp.toIso8601String() +
        Helper.privateApiKey +
        Helper.publicApiKey);
    print(hash);
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  @override
  void dispose() {
    //charBloc.close();
  }
}

HomeController homeC = new HomeController();
