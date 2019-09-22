class OriginalIssue {
  String resourceURI;
  String name;

  OriginalIssue({this.resourceURI, this.name});

  OriginalIssue.fromJson(Map<String, dynamic> json) {
    resourceURI = json['resourceURI'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resourceURI'] = this.resourceURI;
    data['name'] = this.name;
    return data;
  }
}
