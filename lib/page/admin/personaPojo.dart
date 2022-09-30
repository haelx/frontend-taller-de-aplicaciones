class personaPojo {
  final String id;
  final DateTime? createdAt;
  final String name;
  final String? avatar;

  personaPojo(
      {required this.id, this.createdAt, required this.name, this.avatar});

  factory personaPojo.fromJson(Map<String, dynamic> json) {
    return personaPojo(
      id: json["id"],
      createdAt:
      json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      name: json["name"],
      avatar: json["avatar"],
    );
  }

  static List<personaPojo> fromJsonList(List list) {
    return list.map((item) => personaPojo.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///this method will prevent the override of toString
  bool userFilterByCreationDate(String filter) {
    return this.name.toString().contains(filter) ?? false;
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(personaPojo model) {
    return this.id == model.id;
  }
 buscarid(){
    return id;
}
  @override
  String toString() => name;
}