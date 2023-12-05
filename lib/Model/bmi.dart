
import '../Controller/sqlite_db.dart';

class Calc {
  static const String SQLiteTable = "bmi2";

  String name;
  double height;
  double weight;
  String gender;
  String category;

  Calc(this.name, this.height, this.weight, this.gender, this.category);

  Calc.fromJson(Map<String, dynamic> json)
      : name = json ['username'] as String,
        height = json['height'] as double,
        weight = json['weight'] as double,
        gender = json['gender'] as String,
        category = json['status'] as String;


  //toJson will be automically called by jsonEncode when necessary

  Map<String, dynamic> toJson() =>
      {
        'username': name,
        'height': height,
        'weight': weight,
        'gender': gender,
        'status': category
      };

  Future<bool> save() async {
    //save to local SQlite
    //await SQLiteDB().insert(SQLiteTable, toJson());
    if (await SQLiteDB().insert(SQLiteTable, toJson()) != 0) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<Calc>> loadAll() async {
    List<Map<String, dynamic>> result = await SQLiteDB().queryAll(SQLiteTable);
    List<Calc> calc = [];
    for (var item in result) {
      calc.add(Calc.fromJson(item) as Calc);
    }
    return calc;
  }
}



