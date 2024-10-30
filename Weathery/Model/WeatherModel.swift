//
//  WeatherModel.swift
//  Weathery
//
//  Created by Daniel Efrain Ocasio on 10/28/24.
//
import Foundation

struct WeatherDataModel: Decodable {
	
	let weather: [Weather]
	
	let main: MainWeather
	
	let visibility: Int
	
	let wind: Wind
	
	let clouds: Clouds
	
	let sys: Sys
	
	let timezone: Int
	
	let name: String
	
	let cod: Int
}


struct Weather: Decodable {
	
	let id: Int
	
	let main: String
	
	let description: String
	
	let icon: String
	
}

struct MainWeather: Decodable {
	let temp: Double
	
	let feels_like: Double
	
	let temp_min: Double
	
	let temp_max: Double
	
	let pressure: Int
	
	let humidity: Int
}


struct Wind: Decodable {
	let speed: Double
	
	let deg: Int
}


struct Clouds: Decodable {
	let all: Int
}

struct Sys: Decodable {
	let type: Int?
	
	let id: Int?
	
	let country: String
	
	let sunrise: Int
	
	let sunset: Int
}
