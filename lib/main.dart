import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MaterialApp(home: BMICalculator()));
}

class BMICalculator extends StatefulWidget {
  const BMICalculator({Key? key}) : super(key: key);

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  // Weight Controllers
  final TextEditingController weightController = TextEditingController();

  // Height Controllers
  final TextEditingController meterController = TextEditingController();
  final TextEditingController cmController = TextEditingController();
  final TextEditingController ftController = TextEditingController();
  final TextEditingController inchController = TextEditingController();

  // Unit Toggles
  String weightUnit = "kg";
  String heightUnit = "cm";

  double? bmi;
  String category = "";
  Color categoryColor = Colors.grey;

  // ---- Conversion Functions ---- //
  double poundsToKg(double lb) => lb * 0.45359237;
  double cmToMeter(double cm) => cm / 100;
  double feetInchToMeter(double ft, double inch) =>
      ((ft * 12) + inch) * 0.0254;

  // ---- BMI Category ---- //
  void setCategory(double bmi) {
    if (bmi < 18.5) {
      category = "Underweight";
      categoryColor = Colors.blue;
    } else if (bmi < 25) {
      category = "Normal";
      categoryColor = Colors.green;
    } else if (bmi < 30) {
      category = "Overweight";
      categoryColor = Colors.orange;
    } else {
      category = "Obese";
      categoryColor = Colors.red;
    }
  }

  // ---- Main BMI Calculation ---- //
  void calculateBMI() {
    try {
      // Weight
      if (weightController.text.isEmpty) {
        showError("Enter weight");
        return;
      }
      double weight = double.parse(weightController.text);

      if (weightUnit == "lb") weight = poundsToKg(weight);

      // Height
      double heightInMeters;

      if (heightUnit == "m") {
        if (meterController.text.isEmpty) {
          showError("Enter meters");
          return;
        }
        heightInMeters = double.parse(meterController.text);
      } else if (heightUnit == "cm") {
        if (cmController.text.isEmpty) {
          showError("Enter centimeters");
          return;
        }
        heightInMeters = cmToMeter(double.parse(cmController.text));
      } else {
        // ft + in
        if (ftController.text.isEmpty || inchController.text.isEmpty) {
          showError("Enter feet and inches");
          return;
        }
        double ft = double.parse(ftController.text);
        double inch = double.parse(inchController.text);
        heightInMeters = feetInchToMeter(ft, inch);
      }

      if (heightInMeters <= 0) {
        showError("Invalid height");
        return;
      }

      bmi = weight / (heightInMeters * heightInMeters);
      setCategory(bmi!);

      setState(() {});
    } catch (e) {
      showError("Invalid input");
    }
  }

  // ---- Error Message ---- //
  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  // Auto-carry for inches
  void handleInchCarry(String value) {
    if (value.isEmpty) return;

    double inch = double.tryParse(value) ?? 0;
    if (inch >= 12) {
      double ftAdd = inch/12;
      double remaining = inch % 12;

      ftController.text =
          ((double.tryParse(ftController.text) ?? 0) + ftAdd).toString();
      inchController.text = remaining.toStringAsFixed(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputFilter = FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'));

    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI Calculator"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weight Unit Selection
            const Text("Weight Unit", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: "kg", label: Text("KG")),
                ButtonSegment(value: "lb", label: Text("LB")),
              ],
              selected: {weightUnit},
              onSelectionChanged: (u) {
                setState(() => weightUnit = u.first);
              },
            ),
            SizedBox(height: 10,),

            TextField(

              controller: weightController,
              keyboardType: TextInputType.number,
              inputFormatters: [inputFilter],
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                labelText: "Weight ($weightUnit)",
              ),
            ),
            const SizedBox(height: 20),

            // Height Unit Selection
            const Text("Height Unit",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            SegmentedButton<String>(

              segments: const [
                ButtonSegment(value: "m", label: Text("Meter")),
                ButtonSegment(value: "cm", label: Text("CM")),
                ButtonSegment(value: "ft", label: Text("Ft + In")),
              ],
              selected: {heightUnit},
              onSelectionChanged: (u) {
                setState(() => heightUnit = u.first);
              },
            ),

            const SizedBox(height: 10),

            if (heightUnit == "m")
              TextField(
                controller: meterController,
                inputFormatters: [inputFilter],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                    hintStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                    labelText: "Meters"),
              ),

            if (heightUnit == "cm")
              TextField(
                controller: cmController,
                inputFormatters: [inputFilter],
                keyboardType: TextInputType.number,
                decoration:  InputDecoration(
                  enabledBorder: OutlineInputBorder(borderSide:BorderSide (color:Colors.greenAccent )),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                    hintStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                    labelText: "Centimeters"),
              ),

            if (heightUnit == "ft")
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: ftController,
                      inputFormatters: [inputFilter],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                          hintStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                          labelText: "Feet"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: inchController,
                      inputFormatters: [inputFilter],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                        hintStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                        labelText: "Inches", ),
                      onChanged: handleInchCarry,
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 25),

            Center(
              child: ElevatedButton(

                onPressed: calculateBMI,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 50),
                ),
                child: const Text("Calculate BMI", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              ),
            ),

            const SizedBox(height: 20),

            if (bmi != null)
              Card(
                color: categoryColor.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "BMI: ${bmi!.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Chip(
                        backgroundColor: categoryColor,
                        label: Text(
                          category,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
