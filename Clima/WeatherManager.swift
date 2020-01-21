//
//  WeatherManager.swift
//  Clima
//
//  Created by gacordeiro LuizaLabs on 21/01/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=f64fe10e6ec735c8ca03bbb61ee38dda&units=metric"
    
    func fetchWeather(for cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(from: safeData)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(from weatherData: Data) {
        
    }
}
