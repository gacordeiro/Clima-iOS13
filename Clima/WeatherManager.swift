//
//  WeatherManager.swift
//  Clima
//
//  Created by gacordeiro LuizaLabs on 21/01/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, with model: WeatherModel)
    func didFail(with error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=f64fe10e6ec735c8ca03bbb61ee38dda&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(for cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFail(with: error!)
                    return
                }
                
                if let safeData = data {
                    if let model = self.parseJSON(from: safeData) {
                        self.delegate?.didUpdateWeather(self, with: model)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(from weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            return WeatherModel(conditionId: id, cityName: name, temperature: temp)
        } catch {
            delegate?.didFail(with: error)
            return nil
        }
    }
    
    func getConditionName(for weatherId: Int) -> String {
        switch weatherId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    
    struct Main: Decodable {
        let temp: Double
    }
    
    struct Weather: Decodable {
        let id: Int
    }
}

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String  {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
