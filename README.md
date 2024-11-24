## Demand Prediction API and Mobile App
This repository contains a FastAPI-based backend API and a Flutter mobile app for predicting demand for food delivery. The API is publicly accessible and can be tested using Swagger UI.

## Mission
The mission of this project is to provide accurate and timely predictions of food delivery demand to improve operational efficiency for food delivery services.

## Data Source
The dataset used for training the demand prediction model is sourced from Kaggle. It contains various features related to food delivery orders, including weather conditions, road traffic density, type of order, festival occurrences, city, and time-related features. 
Find it here: https://www.kaggle.com/datasets/gauravmalik26/food-delivery-dataset?resource=download

## Publicly Available API Endpoint
The API endpoint is deployed at: https://demand-prediction-dy30.onrender.com 
You can test the API using the Swagger UI at: https://demand-prediction-dy30.onrender.com/docs 

## Video Demo
Watch the YouTube demo video here: https://youtube.com/shorts/bi4FzGCsaP4 

## Running the Mobile App

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- A device or emulator for running the Flutter app
- A publicly accessible API endpoint

### Instructions

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/tomunizua/linear_regression_model.git
   cd summative/FlutterApp
   
2. **Install dependencies**
   ```bash
   flutter pub get

3. **Run the App:**
Connect your device or start an emulator, then run the app:
   ```bash
   flutter run

## Using the App
1. Open the app on your device or emulator.

2. Enter the required details for food delivery demand prediction:
   
    -Order Date (format: YYYY-MM-DD, must start with "20")
   
    -Hour of the day (0 - 23)
   
    -Day of the week (e.g., Monday)
   
    -Is a Festival (yes or no)
   
    -Weather Conditions (Sunny, Cloudy, Stormy, Fog, Windy)
   
    -Road Traffic Density (Low, Medium, High, Jam)
   
    -Type of Order (Meal, Drinks, Snack)
   
    -City (Urban, Semi-Urban, Metropolitian)
   
3. Click the Predict button to get the demand prediction.

### Dataset
This model was trained using this() dataset from Kaggle 
