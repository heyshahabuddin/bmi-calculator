import 'package:flutter/material.dart';
enum HeightType { meter, cm, feetInch }
enum WeightType {kg, pound}
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HeightType heightType = HeightType.meter;
  WeightType weightType = WeightType.kg;

  // controllers
  final kgCtr = TextEditingController();
  final poundCtr = TextEditingController();
  final meterCtr = TextEditingController();
  final cmCtr = TextEditingController();
  final feetCtr = TextEditingController();
  final inchCtr = TextEditingController();
  String _bmiResult = '';
  String? _bmiCategory;
  Color? _bmiCategoryColor;
  String? _bmiCategoryBadge;

  // Weight for KG
  double? kgWeight(){
    final kgWeight= double.tryParse(kgCtr.text.trim());
    if (kgWeight == null || kgWeight <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text("Invalid Weight")
          )
      );
      return null;
    }
    return kgWeight;
  }
  // Weight for Pound
  double? poundToKg(){
    final poundWeight= double.tryParse(poundCtr.text.trim());
    if (poundWeight == null || poundWeight <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text("Invalid Weight")
          )
      );
      return null;
    }
    return poundWeight * 0.45359237;
  }
  // Height for Meter
  double? meterHeight(){
    final meterHeight= double.tryParse(meterCtr.text.trim());
    if (meterHeight == null || meterHeight <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text("Invalid Meter Height")
          )
      );
      return null;
    }
    return meterHeight;
  }
  // Height for CM
  double? cmToMeter(){
    final cmHeight= double.tryParse(cmCtr.text.trim());
    if (cmHeight == null || cmHeight <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text("Invalid CM Height")
          )
      );
      return null;
    }
    return cmHeight * 0.01;
  }
   // Height for CM
  double? feetInchToMeter(){
    final feetHeight= double.tryParse(feetCtr.text.trim());
    final inchHeight= double.tryParse(inchCtr.text.trim());
    if (feetHeight == null || feetHeight <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text("Invalid Feet Height")
          )
      );
      return null;
    }
    if (inchHeight == null || feetHeight <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text("Invalid Inch Height")
          )
      );
      return null;
    }

    final  totalHeight = feetHeight*12 + inchHeight;
    if (totalHeight <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text("Invalid Height")
          )
      );
      return null;
    }

    return totalHeight * 0.0254;
  }
  String bmiCategory(double bmi){
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 25) {
      return 'Normal';
    } else if (bmi < 30) {
      return 'Overweight';
    } else{
      return "Obese";
    }
  }
  Color bmiCategoryColor(String category) {
    switch (category) {
      case "Underweight":
        return Colors.blue;
      case "Normal":
        return Colors.green;
      case "Overweight":
        return Colors.orange;
      default:
        return Colors.red;
    }
  }
  String bmiCategoryBadge(String category) {
    switch (category) {
      case "Underweight":
        return 'underweight.png';
      case "Normal":
        return 'normal.png';
      case "Overweight":
        return 'overweight.png';
      default:
        return 'obese.png';
    }
  }
  void _calculateBMI(){
    // weight
    final weight = weightType == WeightType.kg ? kgWeight() : poundToKg();
    if (weight == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Invalid Weight")
          )
      );
      return;
    }

    // height
    final height;
    if (heightType == HeightType.meter) {
      height = meterHeight();
      if (height == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text("Invalid Height")
        ));
        return;
      }
    }else if (heightType == HeightType.cm) {
      height = cmToMeter();
      if (height == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text("Invalid Height")
        ));
        return;
      }
    }else if(heightType == HeightType.feetInch) {
      height = feetInchToMeter();
      if (height == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text("Invalid Height")
        ));
        return;
      }
    }
    else{
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text("Invalid Height")
        ));
        return;
    }

    final bmi = weight/(height * height);
    final category = bmiCategory(bmi);
    final categoryColor = bmiCategoryColor(category);
    final categoryBadge = bmiCategoryBadge(category);

    setState(() {
      _bmiResult = bmi.toStringAsFixed(2);
      _bmiCategory = category;
      _bmiCategoryColor = categoryColor;
      _bmiCategoryBadge = categoryBadge;
    });
  }

  @override
  void dispose(){
    super.dispose();
    kgCtr.dispose();
    poundCtr.dispose();
    meterCtr.dispose();
    cmCtr.dispose();
    feetCtr.dispose();
    inchCtr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "BMI Calculator",
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF6B55CB),
      ),
      body: ListView(
        // Don't need to use single scroll view for ListView
        padding: EdgeInsets.all(16),
        children: [
          Text(
            "Weight Unit:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16,),
          SegmentedButton<WeightType>(
              segments: [
                const ButtonSegment<WeightType>(
                  value: WeightType.kg,
                  label: Text('KG'),
                ),
                const ButtonSegment<WeightType>(
                  value: WeightType.pound,
                  label: Text('Pound'),
                )
              ],
              selected: {weightType},
              onSelectionChanged: (value) => setState(() =>
                  weightType = value.first
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Color(0xFF6B55CB); // selected button color
                  }
                  return Colors.white; // unselected button background
                }),
                foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white; // text color for selected
                  }
                  return Colors.black; // text color for unselected
                }),
                side: WidgetStateProperty.all(
                  const BorderSide(color: Color(0xFF6B55CB)), // border color
                ),
              ),
          ),
          SizedBox(height: 10,),
          if (weightType == WeightType.kg)...[
            TextFormField(
              controller: kgCtr,
              decoration: InputDecoration(
                label: Text(
                  "Weight (kg)",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ] else...[
            TextFormField(
              controller: poundCtr,
              decoration: InputDecoration(
                label: Text(
                  "Weight (Pound)",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            "Height Unit:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16,),
          SegmentedButton<HeightType>(
            segments: [
              const ButtonSegment<HeightType>(
                value: HeightType.meter,
                label: Text('Meter'),
              ),
              const ButtonSegment<HeightType>(
                value: HeightType.cm,
                label: Text('CM'),
              ),
              const ButtonSegment<HeightType>(
                value: HeightType.feetInch,
                label: Text('Feet/Inch')
              ),
            ],
            selected: {heightType},
            onSelectionChanged: (value) => setState(()=>
              heightType = value.first,
            ),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.selected)) {
                  return const Color(0xFF6B55CB); // selected button color
                }
                return Colors.white; // unselected button background
              }),
              foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white; // text color for selected
                }
                return Colors.black; // text color for unselected
              }),
              side: WidgetStateProperty.all(
                const BorderSide(color: Color(0xFF6B55CB)), // border color
              ),
            ),
          ),
          SizedBox(height: 10,),
          if(heightType == HeightType.meter)...[
            TextFormField(
              controller: meterCtr,
              decoration: InputDecoration(
                label: Text(
                  "Height (meter)",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ] else if(heightType == HeightType.cm)...[
            TextFormField(
              controller: cmCtr,
              decoration: InputDecoration(
                label: Text(
                  "Height (cm)",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                   controller: feetCtr,
                   decoration: InputDecoration(
                     label: Text('Feet',
                       style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                     ),
                     border: OutlineInputBorder(),
                   ),
                  ),
                ),
                SizedBox(width: 16,),
                Expanded(
                  child: TextFormField(
                    controller: inchCtr,
                    onChanged: (value) {
                      final inch = int.tryParse(value) ?? 0;
                      if (inch >= 12) {
                        final extraFeet = inch ~/ 12;
                        final remainingInch = inch % 12;
                        final currentFeet = int.tryParse(feetCtr.text) ?? 0;

                        setState(() {
                          feetCtr.text = (currentFeet + extraFeet).toString();
                          inchCtr.text = remainingInch.toString();
                        });

                        inchCtr.selection = TextSelection.fromPosition(
                          TextPosition(offset: inchCtr.text.length),
                        );
                      }
                    },
                   decoration: InputDecoration(
                     label: Text('Inch',
                       style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                     ),
                     border: OutlineInputBorder(),
                   ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6B55CB)),
            onPressed: _calculateBMI,
            child: Text(
              "Show Result",
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_bmiResult != '')...[
            Text(
              "Result: $_bmiResult",
              style: TextStyle(
                //color: Color(0xFFFFFFFF),
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "Category: $_bmiCategory",
              style: TextStyle(
                color: _bmiCategoryColor ?? Colors.grey,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (_bmiResult != '')...[
              Container(
                child: Image.asset('assets/images/$_bmiCategoryBadge'),
              ),
            ]
          ],

        ],
      ),
    );
  }
}
