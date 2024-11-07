class Type {
  String code;
  String name;

  Type({required this.code, required this.name});

  toMap() {
    return {"code": code, "name": name};
  }

  // accountTypes
  static get faithFul => Type(code: "fidele", name: "Fidèle");
  static get servant =>
      Type(code: "serviteur_de_dieu", name: "Serviteur de Dieu");
  static get singer => Type(code: "chantre", name: "Chantre");

  static List get accountTypes => [
    Type.faithFul,
    Type.servant,
    Type.singer
  ];

  // church types
}

List<Type> churchTypes = [
  Type(code: "CAT", name: "Catholique"),
  Type(code: "EVE", name: "Evangélique"),
  Type(code: "ORT", name: "Orthodoxe"),
  Type(code: "PRO", name: "Protestante")
];

List<Type> servantTypes = [
  Type(code: "APO", name: "Apôtre"),
  Type(code: "EVA", name: "Evangéliste"),
  Type(code: "PAS", name: "Pasteur"),
  Type(code: "PRO", name: "Prophète"),
  Type(code: "DOC", name: "Docteur")
];
