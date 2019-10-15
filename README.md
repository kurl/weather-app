# WEATHER APP

## Intro
The purpose of this app is to retreive the weather in Melbourne.

## Environment

Make sure you signup to [OpenWeatherMap](https://openweathermap.org) and [WeatherStack](https://weatherstack.com) and get your API tokens. You then need to set your environment.

```
export WEATHER_STACK_TOKEN=YOUR_TOKEN
export OPEN_WEATHER_TOKEN=YOUR_TOKEN
```

## Run server
Here is a script to help you start the app using docker.
`./scripts/run`

Or you can start the app with: 
`./main`

## Usage
You can fetch the weather like so:
`curl http://localhost:8080/v1/weather`

The response will output the following JSON payload.
```
{
"wind_speed": 20,
"temperature_degrees": 29
}
```

## Test
You can simply run `rspec`

To run rspec inside a container, here is another script to help:
`./scripts/test` 


## TODO
 - Add puma server
 - docker-compose with nginx
 - Handle API versioning better
 - Handle multiple cities
 - Make city a dynamic GET parameter
 - City validation
 - Add pipeline
 - Add storage
 - Add forcast (and past weather?)
 - Handle Timezones
 - Concurency
