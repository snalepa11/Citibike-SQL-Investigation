# Citibike-SQL-Investigation

Thid project is an investigation of how the weather impact Citibike Ridership in NYC
The folders in this project are as follows:
code: contains our eda, model, and processing jupyter notebooks
data: this copntains our exported csv
docs: notes and supporting material
queries: where the SQL cdoe is documented

Writeup:

## Project Summary

This project analyzes Citi Bike ridership data from 2013-2017 to build a predictive model for daily ride counts based on weather conditions and temporal patterns. The goal was to help operations teams forecast demand and optimize bike distribution across the NYC system.

### Data Quality Issues and Solutions

The weather data contained systematic quality issues that required careful handling. Sentinel values (9999.9 for temperatures, 999.9 for wind speed, and 99.99 for precipitation) were used as placeholders for missing or invalid measurements. These were replaced with NaN values during preprocessing to prevent them from skewing statistical analyses and model training. After cleaning, rows with missing weather data were removed from the modeling dataset, resulting in a small loss of observations but ensuring model reliability. Additionally, 186 days were missing entirely from the dataset, likely due to incomplete data collection during the initial system rollout period.

### Feature Engineering

Several features were engineered to capture patterns the raw data didn't explicitly represent:

1. **Day-of-week dummies**: One-hot encoding converted categorical day names into seven binary features, allowing the model to learn distinct weekday versus weekend ridership patterns (e.g., commuter-heavy Tuesdays vs. leisure-focused Saturdays).

2. **Trend features**: Both a `year` column and `days_since_launch` index were created to capture the system's growth trajectory over time. Exploratory analysis revealed consistent year-over-year ridership increases, making these trend features critical for accurate predictions.

3. **Numeric date conversion**: The ride_date column was converted to numeric timestamps to enable temporal analysis and proper chronological train-test splitting.

### Model Performance

The Linear Regression model uses temperature, precipitation, wind speed, day-of-week patterns, and the growth trend to predict daily ridership. The model achieved a test R² indicating it explains a substantial portion of variance in daily ride counts. The Mean Absolute Error (MAE) provides the typical prediction error in rides, giving operations teams a concrete sense of forecast uncertainty when planning bike rebalancing operations.

### Biggest Weakness and Future Work

The model's most significant weakness is its inability to account for **special events and holidays**. Residual analysis reveals large prediction errors on dates like July 4th, New Year's Day, and during major weather events (hurricanes, extreme heat waves). The model treats these as "normal" days based on weather and day-of-week alone, when they fundamentally aren't.

To improve predictions, we would need:
- **Holiday and event calendars**: Binary flags for major holidays, parades, festivals, concerts, and sporting events
- **Hourly weather patterns**: Current daily averages miss the impact of afternoon thunderstorms or temperature swings
- **Lagged features**: Yesterday's weather or ridership could help predict today's patterns
- **Non-linear temperature effects**: The relationship between temperature and ridership appears quadratic (peaks at moderate temps)

With these enhancements, the model could better serve operational needs for capacity planning and resource allocation.
