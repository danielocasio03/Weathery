//
//  ViewController.swift
//  Weathery
//
//  Created by Daniel Efrain Ocasio on 10/28/24.
//

import Foundation
import UIKit

class HomeController: UIViewController, UISearchControllerDelegate {
	
	
	//MARK: - Declarations
	
	var viewModel = WeatherViewModel(weatherService: WeatherService())
	let searchController = UISearchController(searchResultsController: nil)

	let gradientLayer = CAGradientLayer()
	
	lazy var cityTempLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .white
		label.font = UIFont(name: "AvenirNext-Bold", size: 30)
		label.textAlignment = .center
		label.numberOfLines = 2
		return label
	}()
	
	lazy var weatherCondition: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "AvenirNext-Bold", size: 18)
		label.textAlignment = .center
		label.textColor = .white
		return label
	}()
	
	lazy var greetingLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "AvenirNext-Medium", size: 15)
		label.textAlignment = .center
		label.textColor = .white.withAlphaComponent(0.7)
		return label
	}()
	
	lazy var weatherIconImageView: UIImageView = {
		let image = UIImageView()
		image.translatesAutoresizingMaskIntoConstraints = false
		image.contentMode = .scaleAspectFit
		return image
	}()
	
	//Detail Views
	lazy var highLowView = createWeatherBubble(title: "High & Low", icon: "thermometer.sun", detailOne: "H:", detailTwo: "L:")
	lazy var riseAndSetView = createWeatherBubble(title: "Sun Rise & Set", icon: "sun.and.horizon", detailOne: "Sunrise:", detailTwo: "Sunset:")
	lazy var windSpeedView = createWeatherBubble(title: "Wind", icon: "wind", detailOne: "Speed:", detailTwo: "")
	
	
	//MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupBgGradient()
		setupView()
		updateGreeting()
		setupSearchController()
		
		// Set up ViewModel bindings
		viewModel.onWeatherUpdate = { [weak self] weatherData in
			self?.updateUI(weatherData: weatherData)
		}
		viewModel.locationManagerSetup()
	}
	
	override func viewDidLayoutSubviews() {
		gradientLayer.frame = self.view.bounds
	}
	
	
	//MARK: - UI Setup Methods
	
	//General setup of the view
	private func setupView() {
		//Self
		view.backgroundColor = .blue
		//cityTempLabel
		view.addSubview(cityTempLabel)
		//weatherIconImageView
		view.addSubview(weatherIconImageView)
		//Weather Condition Label
		view.addSubview(weatherCondition)
		//greeting label
		view.addSubview(greetingLabel)
		//WeatherDetailViews
		view.addSubview(windSpeedView)
		view.addSubview(riseAndSetView)
		view.addSubview(highLowView)
		
		NSLayoutConstraint.activate([
			//City Temp Label
			cityTempLabel.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor),
			cityTempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			cityTempLabel.bottomAnchor.constraint(lessThanOrEqualTo: highLowView.topAnchor, constant: -weatherCondition.frame.height + greetingLabel.frame.height),
			//weatherIconImageView
			weatherIconImageView.topAnchor.constraint(equalTo: cityTempLabel.topAnchor),
			weatherIconImageView.leadingAnchor.constraint(equalTo: cityTempLabel.trailingAnchor),
			weatherIconImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 200),
			//Weather Condition Label
			weatherCondition.topAnchor.constraint(equalTo: cityTempLabel.bottomAnchor),
			weatherCondition.bottomAnchor.constraint(lessThanOrEqualTo: greetingLabel.topAnchor, constant: -5),
			weatherCondition.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			//Greeting Label
			greetingLabel.topAnchor.constraint(equalTo: weatherCondition.bottomAnchor, constant: 5),
			greetingLabel.bottomAnchor.constraint(lessThanOrEqualTo: windSpeedView.topAnchor, constant: -5),
			greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			//Wind Speed Bubble
			windSpeedView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			windSpeedView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			windSpeedView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10),
			windSpeedView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
			// Rise and set bubble
			riseAndSetView.bottomAnchor.constraint(equalTo: windSpeedView.topAnchor, constant: -10),
			riseAndSetView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			riseAndSetView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10),
			riseAndSetView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
			// High Low Bubble
			highLowView.bottomAnchor.constraint(equalTo: riseAndSetView.topAnchor, constant: -10),
			highLowView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			highLowView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10),
			highLowView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),


		])
	}
	
	//Method in charge of setting up the background Gradient
	private func setupBgGradient() {
		
		// Set gradient colors
		gradientLayer.colors = [
			UIColor.systemTeal.cgColor,
			UIColor.systemIndigo.cgColor
		]
		
		// Set in gradient size and position
		gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
		gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
		gradientLayer.frame = view.bounds
		view.layer.insertSublayer(gradientLayer, at: 0)
	}
	
	
	
	// Method in charge of updating the greeting label
	private func updateGreeting() {
		let hour = Calendar.current.component(.hour, from: Date())
		let greeting: String
		switch hour {
		case 4..<12:
			greeting = "Good Morning"
		case 12..<18:
			greeting = "Good Afternoon"
		default:
			greeting = "Good Evening"
		}
		greetingLabel.text = greeting
	}
	
	//Method for creating the weather DetailsView's
	private func createWeatherBubble(title: String, icon: String, detailOne: String, detailTwo: String) -> DetailsView {
		let view = DetailsView()
		view.boxTitle.text = title
		view.boxIcon.image = UIImage(systemName: icon)
		view.boxDetailOne.text = detailOne
		view.boxDetailTwo.text = detailTwo
		
		return view
	}
	
	
	//MARK: - Helper Methods
	
	// Method in charge of calling the fetch for a given cities whether
	func fetchWeatherData(cityName: String) {
		//  Defining the Callback to update the UI
		viewModel.onWeatherUpdate = { [weak self] weatherData in
			self?.updateUI(weatherData: weatherData)
		}
		
		viewModel.fetchWeather(for: cityName)
	}
	
	
	// Method in charge of updating the UI once the VC is notified fetch is complete
	func updateUI(weatherData: WeatherDataModel ) {
		cityTempLabel.text =  "\(weatherData.name)\n\(Int(weatherData.main.temp))°"
		weatherCondition.text = weatherData.weather.first?.description
		
		//Fetch and assignment of the weather icon image
		if let iconCode = weatherData.weather.first?.icon {
			viewModel.fetchIconImage(for: iconCode) { [weak self] image in
				self?.weatherIconImageView.image = image
			}
		}
		
		//High Low View
		highLowView.boxDetailOne.text = "H: \(Int(weatherData.main.temp_max))°"
		highLowView.boxDetailTwo.text = "L: \(Int(weatherData.main.temp_min))°"
		//Rise and Set view
		let sunriseTime = viewModel.formatUnixTimestamp(weatherData.sys.sunrise)
		let sunsetTime = viewModel.formatUnixTimestamp(weatherData.sys.sunset)
		riseAndSetView.boxDetailOne.text = "Sunrise: \(sunriseTime)"
		riseAndSetView.boxDetailTwo.text = "Sunset: \(sunsetTime)"
		//Wind Speed View
		windSpeedView.boxDetailOne.text = "Speed: \(weatherData.wind.speed) m/h"
		
	}
	
}

//MARK: - EXT: Search Bar
extension HomeController: UISearchBarDelegate {
	
	// Configure the search controller
	func setupSearchController() {
		searchController.searchBar.delegate = self
		searchController.searchBar.placeholder = "Search for a city"
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
	}
	
	// Called when return key is tapped, fetching for the typed city
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let cityName = searchBar.text, !cityName.isEmpty else { return }
		UserDefaults.standard.set(cityName, forKey: "lastSearchedCity") //  Saves last searched city to user defaults
		fetchWeatherData(cityName: cityName)
		searchBar.resignFirstResponder()
	}
	
}



