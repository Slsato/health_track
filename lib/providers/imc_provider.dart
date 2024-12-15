import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImcProvider extends ChangeNotifier {
  final TextEditingController weightController =
      TextEditingController(text: "");
  final TextEditingController heightController =
      TextEditingController(text: "");
  final TextEditingController ageController = TextEditingController(text: "");
  double imc = 0.0;
  String imcResult = '';


  void submitForm() {
    if (validateFields()) {
      calculateIMC();
      saveData();
    }
  }

  bool validateFields() {
    return weightController.text.isNotEmpty &&
        heightController.text.isNotEmpty &&
        ageController.text.isNotEmpty;
  }

  void calculateIMC() {
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text);
    double heightSquared = height * height;
    double imcCalc = weight / heightSquared;
    String result = _calculateResult(imcCalc);
    imc = double.parse(imcCalc.toStringAsFixed(1));
    imcResult = result;
    notifyListeners();
  }

  String _calculateResult(double imc) {
    if (imc == 0.0) return '';
    if (imc < 18.5) {
      return 'Abaixo do peso';
    } else if (imc >= 18.5 && imc < 24.9) {
      return 'Peso Normal';
    } else if (imc >= 25 && imc < 29.9) {
      return 'Sobrepeso';
    } else {
      return 'Obesidade';
    }
  }

  void saveData() async {
    //TODO: Salva na memória do telefone
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('weight', double.parse(weightController.text));
    await prefs.setDouble('height', double.parse(heightController.text));
    await prefs.setInt('age', int.parse(ageController.text));
    await prefs.setDouble('lastIMC', imc);
  }

  void loadData() async {
    print('loadData');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('weight')) return;
      weightController.text = prefs.getDouble('weight').toString();
      heightController.text = prefs.getDouble('height').toString();
      ageController.text = prefs.getInt('age').toString();
      imc = prefs.getDouble('lastIMC') ?? 0.0;
      imcResult = _calculateResult(imc);
      print(prefs.getDouble('lastIMC'));
      print(imc);
      notifyListeners();
  }

}
