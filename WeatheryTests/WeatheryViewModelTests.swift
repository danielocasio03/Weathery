//
//  WeatheryViewModelTests.swift
//  WeatheryTests
//
//  Created by Daniel Efrain Ocasio on 10/29/24.
//

import XCTest
@testable import Weathery

final class WeatherViewModelTests: XCTestCase {
	
	var viewModel: WeatherViewModel!
	var weatherService: WeatherService!
	
	override func setUp() {
		super.setUp()
		// Initialize the mock service and view model
		weatherService = WeatherService()
		viewModel = WeatherViewModel(weatherService: weatherService)
	}
	
	override func tearDown() {
		viewModel = nil
		weatherService = nil
		super.tearDown()
	}
	
	
	
	//MARK: - Test cases
	
	// Test for fetching weather data -  we are testing whether the fetch accurately fetches for the correct city. in this case Orlando
	func testFetchWeather() {
		// Given
		let city = "Orlando"
		let expectation = XCTestExpectation(description: "Weather data fetched and callback called")
		
		viewModel.onWeatherUpdate = { weatherData in
			XCTAssertEqual(weatherData.name, city, "Fetched weather data should match the requested city")
			expectation.fulfill()
		}
		
		// When
		viewModel.fetchWeather(for: city)
		
		// Then
		wait(for: [expectation], timeout: 2.0)
	}
	
	// Test for icon image fetching - we are testing the icon fetch. given an icon code we are ensuring it returns not nil
	func testFetchIconImage() {
		// Given
		let iconCode = "01d"
		let expectation = XCTestExpectation(description: "Icon image fetched successfully")
		
		viewModel.fetchIconImage(for: iconCode) { image in
			XCTAssertNotNil(image, "Image should not be nil for a valid icon code")
			expectation.fulfill()
		}
		
		// Then
		wait(for: [expectation], timeout: 2.0)
	}
	
}
