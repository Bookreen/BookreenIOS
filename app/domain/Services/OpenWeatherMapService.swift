import Foundation
import Alamofire

struct GetWeatherInput {
    let latitude: Double
    let longitude: Double
}

protocol OpenWeatherMapServiceProtocol: AnyObject {
    func getWeather(input: GetWeatherInput, completion: @escaping (RestApiServiceResult<WeatherModel>) -> Void)
}

final class OpenWeatherMapService: OpenWeatherMapServiceProtocol {
    
    func getWeather(input: GetWeatherInput, completion: @escaping (RestApiServiceResult<WeatherModel>) -> Void) {
        let latitude = input.latitude
        let longitude = input.longitude
        let units = "metric"
        let appId = "1f958dacf1e3bb384705423f9a79ae87"
        
        let urlAsString = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=\(units)&appid=\(appId)"
        guard URL(string: urlAsString) != nil else {
            completion(.failure(AppError.nullUrl))
            return
        }
        
        AF.request(urlAsString, method: .get, parameters: nil, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success(let data):
                guard let _data = data else {
                    completion(.failure(AppError.nullData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    try decoder.configureDateParse()
                    let weatherModel = try decoder.decode(WeatherModel.self, from: _data)
                    completion(.success("", weatherModel))
                } catch {
                    completion(.failure(AppError.serializationError(error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    
    
}
