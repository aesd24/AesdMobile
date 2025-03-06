class Type {
  String code;
  String name;

  Type({required this.code, required this.name});

  toMap() {
    return {"code": code, "name": name};
  }

  // accountTypes
  static Type get faithFul => Type(code: "fidele", name: "Fidèle");
  static Type get servant =>
      Type(code: "serviteur_de_dieu", name: "Serviteur de Dieu");
  static Type get singer => Type(code: "chantre", name: "Chantre");

  static List<Type> get accountTypes => [faithFul, servant, singer];

  // church types
}

List<Type> churchTypes = [
  Type(code: "Catholique", name: "Catholique"),
  Type(code: "Evangelique", name: "Evangélique"),
  Type(code: "Orthodoxe", name: "Orthodoxe"),
  Type(code: "Protestante", name: "Protestante"),
  Type(code: "Baptiste", name: "Baptiste")
];

List<Type> servantTypes = [
  Type(code: "APO", name: "Apôtre"),
  Type(code: "EVA", name: "Evangéliste"),
  Type(code: "PAS", name: "Pasteur"),
  Type(code: "PRO", name: "Prophète"),
  Type(code: "DOC", name: "Docteur")
];
