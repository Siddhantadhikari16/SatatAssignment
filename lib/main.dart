import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  TextEditingController num1Controller = TextEditingController();
  TextEditingController num2Controller = TextEditingController();
  String result = '';
  List<String> calculationHistory = [];
  String quote = '';

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    final response = await http.get(Uri.parse('https://zenquotes.io/api/random'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        quote = jsonData[0]['q'] + " - " + jsonData[0]['a'];
      });
    } else {
      throw Exception('Failed to load quote');
    }
  }
  int? sum=0,num1=0,num2=0;
  void _calculate() {
    num1 = int.parse(num1Controller.text);
     num2 = int.parse(num2Controller.text);

    if (num1 != null && num2 != null) {
      sum = num1! + num2!;
      setState(() {
        result = '$num1 + $num2 = $sum';
        calculationHistory.add(result);
      });
    } else {
      setState(() {
        result = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Siddhant Adhikari Assignment')),
      ),
      body:
      Stack(
        children: [
          Container(
            height: double.maxFinite,
            width: double.maxFinite,
            color: Colors.white,
            // decoration: const BoxDecoration(gradient: RadialGradient(colors:[Colors.cyanAccent,Colors.lightBlueAccent],focalRadius: 20,center: Alignment.center,radius: 0.7)),
        child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Quote of the Day:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    quote,
                    style: const TextStyle(fontSize:25,fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 20),
                  const Text("ADDER",style: TextStyle( fontSize:20,fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 80,
                        child: TextField(
                          controller: num1Controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.zero)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Text("+"),
                      const SizedBox(width: 20,),
                      SizedBox(
                        height: 20,
                        width: 80,
                        child: TextField(
                          controller: num2Controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.zero)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Text(" = "),
                      const SizedBox(width: 20),
                      Container(
                        height: 20,
                        width:80,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(0),border: Border.all(color: Colors.black)),
                        child: Center(
                          child: Text( "$sum",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height:20),
                  ElevatedButton(
                    onPressed: _calculate,
                    child: const Text('Add'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10,bottom: 10),
                    child: Container(height: 1,
                    width: 400,
                        color: Colors.blueGrey,),
                  ),
                  const Text(
                    'Calculation History:',
                    style: TextStyle(fontSize: 20,),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: calculationHistory.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(calculationHistory[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

