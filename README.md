# WEATHER APP

## Intro
The purpose of this app is to retreive the weather in Melbourne.


## Run
#### Set environment

Make sure you signup to [OpenWeatherMap](https://openweathermap.org) and [WeatherStack](https://weatherstack.com) and generate your API keys. You then need to set your enviroment as bellow.

```
export WEATHER_STACK_TOKEN=YOUR_TOKEN
export OPEN_WEATHER_TOKEN=YOUR_TOKEN
```

#### Docker
Start the app: `./scripts/docker_run`
Test the app: `./scripts/docker_test`

#### Locally
Start the app: `./main`
Test the app: `rspec`


## TODO
 - Handle API versionning better
 - Handle multiple cities
 - Make city a dynamic GET parameter
 - City validation
 - Add storage
 - Add forcast (and past weather?)
 - Handle Timezones
 - Concurency
