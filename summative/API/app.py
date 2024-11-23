from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from fastapi.middleware.cors import CORSMiddleware
import joblib
import numpy as np
import uvicorn

# Define FastAPI app
app = FastAPI(
    title="Demand Prediction API",
    description="An API to predict demand using a Linear Regression model.",
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
    order_date: str = Field(..., pattern=r'^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$')
    hour: int = Field(..., ge=0, le=23)
    day_of_week: str
    is_holiday: bool
    weather_conditions: str

    class Config:
        schema_extra = {
            "example": {
                "order_date": "2024-11-23",
                "hour": 14,
                "day_of_week": "Friday",
                "is_holiday": False,
                "weather_conditions": "Sunny"
            }
        }

# Mapping from day names to their respective numbers
day_of_week_map = {
    'monday': 0,
    'tuesday': 1,
    'wednesday': 2,
    'thursday': 3,
    'friday': 4,
    'saturday': 5,
    'sunday': 6
}

def is_weekend(day_of_week: str) -> bool:
    day_of_week_num = day_of_week_map[day_of_week.lower()]
    return day_of_week_num in [5, 6]

@app.post("/predict")
def predict(input_data: PredictionInput):
    try:
        input_dict = input_data.dict()
        day_of_week_num = day_of_week_map[input_dict["day_of_week"].lower()]
        weekend = is_weekend(input_dict["day_of_week"])
        features = [
            input_dict["hour"],
            day_of_week_num,
            int(weekend),
            int(input_dict["is_holiday"]),
            input_dict["weather_conditions"].lower()
        ]

        features_array = np.array(features).reshape(1, -1)
        prediction = model.predict(features_array)
        
        return {"predicted_demand": prediction[0]}
    
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"An error occurred: {e}")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
