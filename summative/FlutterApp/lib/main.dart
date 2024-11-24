import 'package:flutter/material.dart';
import 'api_service.dart'; 
import 'prediction_input.dart';

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
  final TextEditingController festivalController = TextEditingController(); 
  
  String? selectedweatherCondition; 
  String? selectedroadTrafficDensity; 
  String? selectedtypeOfOrder; 
  String? selectedcity; 

  List<String> weatherConditions = ['Cloudy', 'Fog', 'Stormy', 'Sunny', 'Windy']; 
  List<String> roadTrafficDensity = ['Low', 'Medium', 'High', 'Jam']; 
  List<String> typeOfOrder = ['Drinks', 'Meal', 'Snack']; 
  List<String> city = ['Metropolotian', 'Semi-Urban', 'Urban'];
  
  String predictionResult = '';

  void predict() async { 
    if (_formKey.currentState!.validate() && 
        selectedweatherCondition != null && 
        selectedroadTrafficDensity != null && 
        selectedtypeOfOrder != null && 
        selectedcity != null ) { 
      final input = PredictionInput( 
        weatherconditions: selectedweatherCondition!, 
        roadTrafficDensity: selectedroadTrafficDensity!, 
        typeOfOrder: selectedtypeOfOrder!, 
        festival: festivalController.text.toLowerCase() == 'true' ? 'yes' : 'no', 
        city: selectedcity!, 
        hour: int.parse(hourController.text), 
        dayOfWeek: dayOfWeekController.text, 
        orderDate: orderDateController.text, 
      ); 
      
      try { 
        final result = await ApiService().predictDemand(input); 
        setState(() { 
          predictionResult = 'The predicted demand is: ${result['predicted_demand']} deliveries'; 
        }); 
      } catch (e) { 
        setState(() { 
          predictionResult = 'Error: $e'; 
        }); 
      } 
    } else { 
      setState(() { 
        predictionResult = 'Error: Please enter valid values.'; 
      }); 
      } 
    } 
    
  bool isValidDate(String input) { 
    final regex = RegExp(r'^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$'); 
    return regex.hasMatch(input); }

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
              SizedBox(height: 15),
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
              // SizedBox(height: 12),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hour of the day', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: hourController,
                      decoration: InputDecoration(
                        hintText: '24 hour format e.g., 05',
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
              // SizedBox(height: 12),
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
              // SizedBox(height: 12),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Is there any festival?', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: festivalController,
                      decoration: InputDecoration(
                        hintText: 'yes or no',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || !(value.toLowerCase() == 'yes' || value.toLowerCase() == 'no')) {
                          return 'Please enter yes or no';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 12),
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
                      value: selectedweatherCondition,
                      items: weatherConditions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedweatherCondition = newValue;
                        });
                      },
                      validator: (value) => value == null ? 'Please select a weather condition' : null,
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 12), 
              Container( 
                width: double.infinity, 
                child: Column( 
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [ 
                    Text('Road Traffic Density', style: TextStyle(fontWeight: FontWeight.bold)), 
                    DropdownButtonFormField<String>( 
                      decoration: InputDecoration( 
                        border: OutlineInputBorder( 
                          borderRadius: BorderRadius.circular(12.0), 
                        ), 
                      ), 
                      value: selectedroadTrafficDensity, 
                      items: roadTrafficDensity.map((String value) { 
                        return DropdownMenuItem<String>( 
                          value: value, 
                          child: Text(value), 
                        ); 
                        }).toList(), 
                        onChanged: (newValue) { 
                          setState(() { 
                            selectedroadTrafficDensity = newValue; 
                          }); 
                        }, 
                        validator: (value) => value == null ? 'Please select a road traffic density' : null, 
                        ), 
                      ], 
                    ), 
                  ),
              Container( 
                width: double.infinity, 
                child: Column( 
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [ 
                    Text('Type of Order', style: TextStyle(fontWeight: FontWeight.bold)), 
                    DropdownButtonFormField<String>( 
                      decoration: InputDecoration( 
                        border: OutlineInputBorder( 
                          borderRadius: BorderRadius.circular(12.0), 
                        ), 
                      ), 
                      value: selectedtypeOfOrder, 
                      items: typeOfOrder.map((String value) { 
                        return DropdownMenuItem<String>( 
                          value: value, 
                          child: Text(value), 
                        ); 
                        }).toList(), 
                        onChanged: (newValue) { 
                          setState(() { 
                            selectedtypeOfOrder = newValue; 
                          }); 
                        }, 
                        validator: (value) => value == null ? 'Please select a road traffic density' : null, 
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
              SizedBox(height: 10),
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
