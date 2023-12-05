import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Model/bmi.dart';


class bmicalculator extends StatelessWidget {
  const bmicalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home: BmiList(),
    );
  }
}

class BmiList extends StatefulWidget {
  const BmiList({super.key});

  @override
  State<BmiList> createState() => _BmiListState();
}

class _BmiListState extends State<BmiList> {

  final List<Calc> calcbmi = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  var gender;
  var category;
  double bmi = 0.0 ;
  var _bmi;

  @override
  void initState() {
    super.initState();

    // Load BMI data from the database and populate text fields
    _loadBmiData();
  }

  void _loadBmiData() async {
    // Assuming you have a method in your Calc class to load all BMI data
    final List<Calc> loadedBmiData = await Calc.loadAll();

    if (loadedBmiData.isNotEmpty) {
      final Calc lastBmiEntry = loadedBmiData.last;

      setState(() {
        nameController.text = lastBmiEntry.name;
        heightController.text = lastBmiEntry.height.toString();
        weightController.text = lastBmiEntry.weight.toString();
        statusController.text = lastBmiEntry.category;
        gender = lastBmiEntry.gender;
      });
    }
  }
  void _addinfo() async{
    String name = nameController.text.trim();
    String height = heightController.text.trim();
     String weight = weightController.text.trim();
     String status = statusController.text.trim();
     String genders = gender ;
    if (name.isNotEmpty && height.isNotEmpty && weight.isNotEmpty ) {
      Calc cal =
      Calc(name,double.parse(height),double.parse(weight),genders,status);
      if (await cal.save()){
        //setState(() {
            //_calculateBMI();
        print ("success");

        //});
      } else{
        _showMessage("Failed to save Expenses data");

      }
    }
  }

  void _calculateBMI() {
    double _weight = double.parse(weightController.text);
    double _height = double.parse(heightController.text) / 100; // converting cm to meters

    double bmiTemp = _weight / (_height * _height);
    print(bmiTemp);

    setState(() {
      if (gender == 'Male') {
        if (bmiTemp < 18.5) {
          category = 'Underweight. Careful during strong wind!';
        } else if (bmiTemp >= 18.5 && bmiTemp < 24.9) {
          category = 'That is ideal! Please maintain';
        } else if (bmiTemp >= 25 && bmiTemp < 30) {
          category = 'Overweight! Work out please';
        } else {
          category = 'Whoa obese! Dangerous mate!';
        }
      } else if (gender == 'Female') {
        if (bmiTemp < 16) {
          category = 'Underweight. Careful during strong wind!';
        } else if (bmiTemp >= 16 && bmiTemp < 22) {
          category = 'That is ideal! Please maintain';
        } else if (bmiTemp >= 22 && bmiTemp < 27) {
          category = 'Overweight! Work out please';
        } else {
          category = 'Whoa obese! Dangerous mate!';
        }
      }

      // Set the calculated BMI value
      bmiController.text = bmiTemp.toStringAsFixed(2);

      // Set the BMI status
      statusController.text = category;

      _bmi = bmiController.text;
    });
    setState(() {
      _addinfo();
    });
  }



void _showMessage(String msg){
    if (mounted) {
      //make sure this context is still mounted/exist
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
      ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                  labelText:'Your Fullname',
                ),
              ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: heightController,
                  decoration: InputDecoration(
                    labelText: 'height in cm',
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: weightController,
                  decoration: InputDecoration(
                    labelText: 'Weight in KG',
                  ),
                ),
              ),

              Padding(
                //new textfield for the date and time
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: bmiController,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: 'BMI Value'
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: const Text('Male'),
                          leading: Radio(
                            value: 'Male',
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value.toString();
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('Female'),
                          leading: Radio(
                            value: 'Female',
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value.toString();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  ),

              ElevatedButton(
              onPressed: _calculateBMI,
              child: Text('Calculate BMI and Save'),
              ),
              SizedBox(height: 10),

              _bmi != 0
                  ? Text(
                "Your BMI is $_bmi",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              )
                  : SizedBox(),

              Text(
                statusController.text,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ],
    ),
    );
  }
}

