//
//  WeaterService.swift
//  Weathery
//
//  Created by Daniel Efrain Ocasio on 10/28/24.
//

import Foundation
import Combine

class WeatherService {
	
	private let apiKey = "cd67f3abf51eb2069e963228d3f0e6fa"
	private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
	
	//Method in charge of fetching the weather from the API; returns a publisher for a given city
	func fetchWeather(for city: String) -> AnyPublisher<WeatherDataModel, Error> {
		guard let url = URL(string: "\(baseURL)?q=\(city)&units=imperial&appid=\(apiKey)") else {
			return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
		}
		
		return URLSession.shared.dataTaskPublisher(for: url)
			.map { $0.data }
			.decode(type: WeatherDataModel.self, decoder: JSONDecoder())
			.eraseToAnyPublisher()
	}
}
