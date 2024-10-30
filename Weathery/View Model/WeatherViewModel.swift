//
//  WeatherViewModel.swift
//  Weathery
//
//  Created by Daniel Efrain Ocasio on 10/28/24.
//

import Foundation
import Combine
import CoreLocation
import UIKit

class WeatherViewModel: NSObject {
		
	//MARK: - Declarations
	private var cancellables = Set<AnyCancellable>() // Cancellables
	private let weatherService: WeatherService // dependency injection container for the weather service
	var onWeatherUpdate: ((WeatherDataModel) -> Void)? // Callback closure for data updates; acts as a notifier
	
	let locationManager = CLLocationManager()
	private var geocoder = CLGeocoder()

	
	//MARK: - Initializer
	init(weatherService: WeatherService) {
		self.weatherService = weatherService
		super.init()
		locationManager.delegate = self
	}
	
	//MARK: - Methods
	
	//Method that calls the fetch method in Weather Service. Then handles data passing it back to the VC, storing cancellables
	func fetchWeather(for city: String) {
		weatherService.fetchWeather(for: city)
			.receive(on: RunLoop.main)
			.sink(receiveCompletion: { completion in
				if case .failure(let error) = completion {
					print("Error fetching weather: \(error)")
				}
			}, receiveValue: { [weak self] weatherData in
				self?.onWeatherUpdate?(weatherData) // Callback to update the view
			})
			.store(in: &cancellables)
	}
	
	
	//Fetches for the weather icon image with a given icon asynchronously to avoid performance issues or UI bottlenecks
	func fetchIconImage(for iconCode: String, completion: @escaping (UIImage?) -> Void) {
		let iconURLString = "https://openweathermap.org/img/wn/\(iconCode)@2x.png"
		guard let url = URL(string: iconURLString) else {
			completion(nil)
			return
		}
		
		// Perform the image download asynchronously
		DispatchQueue.global().async {
			if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
				DispatchQueue.main.async {
					completion(image) // Return image on main thread
				}
			} else {
				DispatchQueue.main.async {
					completion(nil)
				}
			}
		}
	}
	
	//Method in charge of loading last searched city if location was denied
	private func loadLastSearchedCity() {
		let lastSearchedCity = UserDefaults.standard.string(forKey: "lastSearchedCity") ?? "Orlando"
		fetchWeather(for: lastSearchedCity)

	}
	
	
	//Method in charge of converting Unix time to users standard timezone format
	func formatUnixTimestamp(_ timestamp: Int) -> String {
		let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "h:mm a"
		dateFormatter.timeZone = TimeZone.current
		return dateFormatter.string(from: date)
	}
	
}


//MARK: - EXT: Core Location
extension WeatherViewModel: CLLocationManagerDelegate {
	
	func locationManagerSetup() {
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		checkLocationAuthorizationStatus()  // Call the new method to handle initial authorization
	}
	
	func checkLocationAuthorizationStatus() {
		// Check the location authorization status
		let status = locationManager.authorizationStatus
		
		switch status {
		case .authorizedWhenInUse, .authorizedAlways:
			locationManager.startUpdatingLocation()
		case .notDetermined:
			locationManager.requestWhenInUseAuthorization()
		case .denied, .restricted:
			loadLastSearchedCity()  // Handle cases where permission is denied
		default:
			break
		}
	}
	
	
	// Method to monitor changes in authorization
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		checkLocationAuthorizationStatus()
	}
	
	// Method called when location is updated
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		locationManager.stopUpdatingLocation()
		
		guard let location = locations.first else {
			return
		}
		
		let geocoder = CLGeocoder()
		geocoder.reverseGeocodeLocation(location) { placeMark, error in
			let placeMark = placeMark?.first
			guard let city = placeMark?.locality else {
				return
			}
			self.fetchWeather(for: city)
			print(city)
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
	}
}
