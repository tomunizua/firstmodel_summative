import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: PredictionPage(),
    );
  }
}

class PredictionPage extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController orderDateController = TextEditingController();
  final TextEditingController hourController = TextEditingController();
  final TextEditingController dayOfWeekController = TextEditingController();
  final TextEditingController isHolidayController = TextEditingController();
  String? selectedWeatherCondition;

  List<String> weatherConditions = ['Sunny', 'Cloudy', 'Stormy', 'Windy', 'Fog'];

  String predictionResult = '';

  void predict() {
    if (_formKey.currentState!.validate() && selectedWeatherCondition != null) {
      // Simulate a prediction - replace with actual API call
      setState(() {
        predictionResult = 'The predicted demand is: 42 deliveries';
      });
    } else {
      setState(() {
        predictionResult = 'Error: Please enter valid values.';
      });
    }
  }

 bool isValidDate(String input) {
  final regex = RegExp(r'^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$');
  return regex.hasMatch(input);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 10, 120, 211),
        foregroundColor: Colors.white,
        title: Text('Demand Prediction App')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Enter Details for Food Delivery Demand Prediction',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 18),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order Date', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: orderDateController,
                      decoration: InputDecoration(
                        hintText: 'YYYY-MM-DD',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || !isValidDate(value)) {
                          return 'Please enter a valid date in YYYY-MM-DD format';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hour of the day', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: hourController,
                      decoration: InputDecoration(
                        hintText: '24 hour format',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty || int.tryParse(value) == null || int.parse(value) < 0 || int.parse(value) > 23) {
                          return 'Please enter a valid hour (0 - 23)';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Day of the Week', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: dayOfWeekController,
                      decoration: InputDecoration(
                        hintText: 'e.g., Monday',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a day of the week';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Is a Holiday (true/false)', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: isHolidayController,
                      decoration: InputDecoration(
                        hintText: 'true or false',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || !(value.toLowerCase() == 'true' || value.toLowerCase() == 'false')) {
                          return 'Please enter true or false';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Weather Conditions', style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      value: selectedWeatherCondition,
                      items: weatherConditions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedWeatherCondition = newValue;
                        });
                      },
                      validator: (value) => value == null ? 'Please select a weather condition' : null,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: predict,
                  child: Text('Predict'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 10, 120, 211),
                    foregroundColor: Colors.white,
                    minimumSize: Size(250, 40), 
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                predictionResult,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
