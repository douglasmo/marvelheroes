import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../../Models/Personagem.dart';
import '../Helper.dart';

class MarvelController {
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
  //fim bloc personagem

  //Bloc loader

  BehaviorSubject<bool> loadBloc = new BehaviorSubject<bool>();
  Sink<bool> get inLoad => loadBloc.sink;
  Stream<bool> get outLoad => loadBloc.stream;
  //fim bloc loader

  final String _assunto = "characters";

  MarvelController() {
    inLoad.add(false);
    getValues("characters");
  }

  gerarHash() {
    hash = generateMd5(timeStamp.toIso8601String() +
        Helper.privateApiKey +
        Helper.publicApiKey);
    print(hash);
  }

  getValues(String assunto) {
    lista = new List();

    gerarHash();
    String urlFinal =
        "$url$assunto?apikey=${Helper.publicApiKey}&hash=$hash&ts=${timeStamp.toIso8601String()}";
    print(urlFinal);
    http.get(urlFinal).then((v) {
      // print(jsonDecode(v.body)["data"]["results"]);
      var personagens = jsonDecode(v.body)["data"]["results"];
      for (var a in personagens) {
        personagem = new Personagem.fromJson(a);
        lista.add(personagem);
      }
      print(lista);
      inPerson.add(lista);
    });
  }

  searchName(String query) {
    lista = new List();

    gerarHash();
    String urlFinal = "$url$_assunto?" +
        "nameStartsWith=$query" +
        "&apikey=${Helper.publicApiKey}&hash=$hash&ts=${timeStamp.toIso8601String()}";
    print(urlFinal);
    http.get(urlFinal).then((v) {
      // print(jsonDecode(v.body)["data"]["results"]);
      var personagens = jsonDecode(v.body)["data"]["results"];
      for (var a in personagens) {
        personagem = new Personagem.fromJson(a);
        lista.add(personagem);
      }
      print(lista);
      inPerson.add(lista);
    });
  }

  getMoreValues(String assunto, int length) {
    inLoad.add(true);
    print(length);
    gerarHash();
    String urlFinal = "http://gateway.marvel.com/v1/public/"
        "$assunto?"
        "offset=$length"
        "&apikey=${Helper.publicApiKey}"
        "&hash=$hash"
        "&ts=${timeStamp.toIso8601String()}";
    print(urlFinal);
    http.get(urlFinal).then((v) {
      // print(jsonDecode(v.body)["data"]["results"]);
      var personagens = jsonDecode(v.body)["data"]["results"];
      for (var a in personagens) {
        personagem = new Personagem.fromJson(a);
        lista.add(personagem);
      }
      print(lista);
      inPerson.add(lista);
      inLoad.add(false);
    });
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}

MarvelController mC = new MarvelController();
