import 'Comics.dart';
import 'Thumbnail.dart';

class Personagem {
  int id;
  String name;
  String description;
  String modified;
  Thumbnail thumbnail;
  String resourceURI;
  Comics comics;
  bool clicked = false;

  Personagem(
      {this.id,
      this.name,
      this.description,
      this.modified,
      this.thumbnail,
      this.resourceURI,
      this.comics});

  Personagem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    modified = json['modified'];
    thumbnail = json['thumbnail'] != null
        ? new Thumbnail.fromJson(json['thumbnail'])
        : null;
    resourceURI = json['resourceURI'];
    comics =
        json['comics'] != null ? new Comics.fromJson(json['comics']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['modified'] = this.modified;
    if (this.thumbnail != null) {
      data['thumbnail'] = this.thumbnail.toJson();
    }
    data['resourceURI'] = this.resourceURI;
    if (this.comics != null) {
      data['comics'] = this.comics.toJson();
    }
    return data;
  }
}
