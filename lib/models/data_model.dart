class DataModel {
  List<Tags>? tags;

  DataModel({this.tags});

  DataModel.fromJson(Map<String, dynamic> json) {
    if (json['tags'] != null) {
      tags = [];
      json['tags'].forEach((v) {
        tags!.add(Tags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tags {
  List<String>? spaceList;
  String? sId;
  String? title;
  String? displayName;
  String? meta;
  String? description;
  int? iV;

  Tags(
      {this.spaceList,
      this.sId,
      this.title,
      this.displayName,
      this.meta,
      this.description,
      this.iV});

  Tags.fromJson(Map<String, dynamic> json) {
    spaceList = json['spaceList'].cast<String>();
    sId = json['_id'];
    title = json['title'];
    displayName = json['displayName'];
    meta = json['meta'];
    description = json['description'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['spaceList'] = spaceList;
    data['_id'] = sId;
    data['title'] = title;
    data['displayName'] = displayName;
    data['meta'] = meta;
    data['description'] = description;
    data['__v'] = iV;
    return data;
  }
}
