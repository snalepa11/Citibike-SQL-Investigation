WITH daily_rides AS (
  SELECT
    DATE(starttime) AS ride_date,
    COUNT(*) AS num_rides,
    ROUND(AVG(tripduration / 60), 2) AS avg_duration_min
  FROM
    `bigquery-public-data.new_york_citibike.citibike_trips`
  WHERE
    starttime >= '2013-01-01' AND starttime < '2019-01-01'
  GROUP BY
    ride_date
),

daily_weather AS (
  SELECT
    PARSE_DATE('%Y-%m-%d', CONCAT(year, '-', mo, '-', da)) AS obs_date,
    temp AS temp_f,
    `max` AS max_temp_f,
    `min` AS min_temp_f,
    wdsp AS wind_speed_knots,
    prcp AS precip_in
  FROM
    `bigquery-public-data.noaa_gsod.gsod20*`
  WHERE
    _TABLE_SUFFIX BETWEEN '13' AND '18'
    AND stn = '725030'
    AND wban = '14732'
)

SELECT
  r.ride_date,
  r.num_rides,
  r.avg_duration_min,
  w.temp_f,
  w.max_temp_f,
  w.min_temp_f,
  w.wind_speed_knots,
  w.precip_in,
  FORMAT_DATE('%A', r.ride_date) AS day_of_week,
  EXTRACT(MONTH FROM r.ride_date) AS month
FROM
  daily_rides AS r
INNER JOIN
  daily_weather AS w
ON
  r.ride_date = w.obs_date
ORDER BY
  r.ride_date ASC;