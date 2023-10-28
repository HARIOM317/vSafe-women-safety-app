class TContactModel {
  int? _id;
  String? _number;
  String? _name;

  TContactModel(this._number, this._name);
  TContactModel.withId(this._id, this._number, this._name);

  // getter
  int get id => _id!;
  String get number => _number!;
  String get name => _name!;

  @override
  String toString() {
    return 'Contact: {id: $_id, name: $_name, number: $_number}';
  }

  // setter
  set number(String newNumber) => _number = newNumber;
  set name(String newName) => _name = newName;

  // convert a Contact object to a map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['id'] = _id;
    map['number'] = _number;
    map['name'] = _name;

    return map;
  }

  TContactModel.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _number = map['number'];
    _name = map['name'];
  }
}