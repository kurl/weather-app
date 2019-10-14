module Provider
  module Types
    include Dry.Types()
  end

  class WeatherStackResponse < Dry::Struct
    attribute :current do
      attribute :wind_speed, Types::Coercible::Integer
      attribute :temperature, Types::Coercible::Integer
    end
  end

  class OpenWeatherResponse < Dry::Struct
    attribute :main do
      attribute :temp, Types::Coercible::Integer
    end
    attribute :wind do
      attribute :speed, Types::Coercible::Float
    end
  end

  class CurrentWeather < Dry::Struct
    attribute :wind_speed, Types::Strict::Integer
    attribute :temperature_degrees, Types::Strict::Integer
  end
end
