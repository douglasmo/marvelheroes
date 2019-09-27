import 'dart:convert';

import 'package:crypto/crypto.dart';

class Helper {
  static String publicApiKey = "8a66fe6fafa5f02f639de71ba4e40118";
  static String privateApiKey = "ba0d2d8b1b4d29aff016dd165a0497af68fadbc0";
}

var url = "http://gateway.marvel.com/v1/public/";
var timeStamp = DateTime.now();
var hash;

String gerarUrl(String assunto, {String adicional = ""}) {
  gerarHash();
  String urlFinal =
      "$url$assunto?apikey=${Helper.publicApiKey}&hash=$hash&ts=${timeStamp.toIso8601String()}$adicional";
  print(urlFinal);
  return urlFinal;
}

gerarHash() {
  hash = generateMd5(
      timeStamp.toIso8601String() + Helper.privateApiKey + Helper.publicApiKey);
  print(hash);
}

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}
