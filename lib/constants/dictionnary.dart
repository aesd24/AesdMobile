class Type {
  int id;
  String code;
  String name;
  
  Type({
    required this.id,
    required this.code,
    required this.name
  });

  toMap(){
    return {
      "id" : id,
      "code" : code,
      "name" : name
    };
  }
}

List<Type> accountTypes = [
  Type(id: 1, code: "FTF", name: "Fidèle"),
  Type(id: 2, code: "SVT", name: "Serviteur de Dieu")
  //Type(id: 3, code: "SIG", name: "Chantre")
];

List<Type> churchTypes = [
  Type(id: 4, code: "CAT", name: "Catholique"),
  Type(id: 5, code: "EVE", name: "Evangélique"),
  Type(id: 6, code: "ORT", name: "Orthodoxe"),
  Type(id: 7, code: "PRO", name: "Protestante")
];

List<Type> servantTypes = [
  Type(id: 8, code: "APO", name: "Apôtre"),
  Type(id: 9, code: "EVA", name: "Evangéliste"),
  Type(id: 10, code: "PAS", name: "Pasteur"),
  Type(id: 11, code: "PRO", name: "Prophète"),
  Type(id: 12, code: "DOC", name: "Docteur")
];