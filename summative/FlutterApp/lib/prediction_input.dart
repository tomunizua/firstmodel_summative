class PredictionInput {
  final String weatherconditions;
  final String roadTrafficDensity;
  final String typeOfOrder;
  final String festival;
  final String city;
  final int hour;
  final String dayOfWeek;
  final String orderDate;

  PredictionInput({
    required this.weatherconditions,
    required this.roadTrafficDensity,
    required this.typeOfOrder,
    required this.festival,
    required this.city,
    required this.hour,
    required this.dayOfWeek,
    required this.orderDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'Weatherconditions': weatherconditions,
      'Road_traffic_density': roadTrafficDensity,
      'Type_of_order': typeOfOrder,
      'Festival': festival,
      'City': city,
      'hour': hour,
      'day_of_week': dayOfWeek,
      'order_date': orderDate,
    };
  }
}
