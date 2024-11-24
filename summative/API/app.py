from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field, model_validator
from fastapi.middleware.cors import CORSMiddleware
import joblib
import numpy as np
import uvicorn
import datetime

# Define FastAPI app
app = FastAPI(
    title="Demand Prediction API",
    description="An API to predict demand for food deliveries using a Decision Tree model.",
    version="1.0"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load the saved model
model = joblib.load('best_model.pkl')

# Define the input data model using Pydantic
class PredictionInput(BaseModel):
    Weatherconditions: str 
    Road_traffic_density: str 
    Type_of_order: str 
    Festival: str = Field(..., pattern="^(no|yes)$")
    City: str 
    hour: int = Field(..., ge=0, le=23)
    day_of_week: str = Field(..., pattern="^(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)$")
    order_date: int = Field(..., pattern=r'^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$')

    class Config:
        schema_extra = {
            "example": {
                "Weatherconditions": "sunny",
                "Road_traffic_density": "medium",
                "Type_of_order": "Snack",
                "Festival": "no",
                "City": "Urban",
                "hour": 14,
                "day_of_week": "Friday",
                "order_date": 2024-11-23
            }
        }

    @model_validator 
    def validate_order_date(cls, values):
        order_date = values.get('order_date')
        try: 
            datetime.datetime.strptime(order_date, '%Y-%m-%d') 
        except ValueError: 
            raise ValueError('Order date must be in YYYY-MM-DD format') 
        return values

# Mapping dictionaries
weather_conditions_map = {
    'Cloudy': 0,
    'Fog': 1,
    'Sandstorms': 3,
    'Stormy': 4,
    'Sunny': 5,
    'Windy': 6,
}

road_traffic_density_map = {
    'High': 0,
    'Jam': 1,
    'Low': 2,
    'Medium': 3
}

type_of_order_map = {
    'Drinks': 0,
    'Meal': 1,
    'Snack': 2
}

festival_map = {
    'no': 1,
    'yes': 2
}

city_map = {
    'Metropolitian': 0,
    'Semi-Urban': 2,
    'Urban': 3
}

day_of_week_map = {
    'Monday': 0,
    'Tuesday': 1,
    'Wednesday': 2,
    'Thursday': 3,
    'Friday': 4,
    'Saturday': 5,
    'Sunday': 6
}

@app.post("/predict")
def predict(input_data: PredictionInput):
    try:
        input_dict = input_data.dict()
        weather_conditions_num = weather_conditions_map[input_dict["Weatherconditions"]]
        road_traffic_density_num = road_traffic_density_map[input_dict["Road_traffic_density"]]
        type_of_order_num = type_of_order_map[input_dict["Type_of_order"]]
        festival_num = festival_map[input_dict["Festival"].lower()]
        city_num = city_map[input_dict["City"]]
        day_of_week_num = day_of_week_map[input_dict["day_of_week"].lower()]
        
        features = [
            weather_conditions_num,
            road_traffic_density_num,
            type_of_order_num,
            festival_num,
            city_num,
            input_dict["hour"],
            day_of_week_num,
            int(input_dict["order_date"].split('-')[2])
        ]

        features_array = np.array(features).reshape(1, -1)
        prediction = model.predict(features_array)
        
        return {"predicted_demand": prediction[0]}
    
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"An error occurred: {e}")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
