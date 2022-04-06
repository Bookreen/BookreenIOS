import Foundation

struct WeatherModel: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case coord = "coord"
        case weather = "weather"
        case base = "base"
        case main = "main"
        case visibility = "visibility"
        case wind = "wind"
        case clouds = "clouds"
        case dt = "dt"
        case sys = "sys"
        case timezone = "timezone"
        case id = "id"
        case name = "name"
        case cod = "cod"
    }
    
    let coord: CoordModel
    let weather: [WeatherInformationModel]
    let base: String
    let main: WeatherMainModel
    let visibility: Int
    let wind: WindWeatherModel
    let clouds: CloudWeatherModel
    let dt: Int
    let sys: SysWeatherModel
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct CoordModel: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case lon = "lon"
        case lat = "lat"
    }
    
    let lon: Double
    let lat: Double
}

struct WeatherInformationModel: Decodable {
    public enum CodingKeys: String, CodingKey {
        case id = "id"
        case main = "main"
        case description = "description"
        case icon = "icon"
    }
    
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct WeatherMainModel: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure = "pressure"
        case humidity = "humidity"
    }
    
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    
}

struct WindWeatherModel: Decodable {
    public enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case deg = "deg"
    }
    
    let speed: Double
    let deg: Int
}

struct CloudWeatherModel: Decodable {
    public enum CodingKeys: String, CodingKey {
        case all = "all"
    }
    
    let all: Int
}


struct SysWeatherModel: Decodable {
    public enum CodingKeys: String, CodingKey {
        case type = "type"
        case id = "id"
        case country = "country"
        case sunrise = "sunrise"
        case sunset = "sunset"
    }
    
    let id: Int
    let type: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}
