//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Prashant Gaikwad on 03/07/21.
//

import XCTest
import CoreLocation
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    var lat: Double?
    var long: Double?
    
    override func setUp() {
        lat = 18.5204
        long = 73.8567
    }
    
    override func tearDown() {
        lat = nil
        long = nil
    }

    func test_getTodaysWeather() {
        let apiManager = APIManager()
        let expectation = self.expectation(description: "Server reponds in time")
        
        guard let lat = lat,
              let long = long else {
            XCTFail()
            return
        }
        
        apiManager.getTodaysWeather(latitude: lat, longitude: long) { (response) in
            defer { expectation.fulfill() }
            XCTAssertNotNil(response)
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_getWeekWeather() {
        let apiManager = APIManager()
        let expectation = self.expectation(description: "Server reponds in time")
        
        guard let lat = lat,
              let long = long else {
            XCTFail()
            return
        }
        
        apiManager.getWeekWeather(latitude: lat, longitude: long) { (response) in
            defer { expectation.fulfill() }
            XCTAssertNotNil(response)
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_getWeatherData() {
        let apiManager = APIManager()
        let expectation = self.expectation(description: "Server reponds in time")
        
        guard let lat = lat,
              let long = long else {
            XCTFail()
            return
        }
        
        apiManager.getWeatherData(latitude: lat, longitude: long) { (response) in
            defer { expectation.fulfill() }
            XCTAssertNotNil(response)
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_getAddressFromLatLong() {
        let expectation = self.expectation(description: "lat,Long To Address")
        
        guard let lat = lat,
              let long = long else {
            XCTFail()
            return
        }
        
        let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        Utils.shared.getAddressFromLatLon(coordinate: coordinates) { (result) in
            defer { expectation.fulfill() }
            XCTAssertEqual("Kasba Peth", result ?? "")
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_getTodaysDate() {
        let currentDate = "Sunday, July 4, 2021"
        let todaysDate = Date.getTodaysDate()
        XCTAssertEqual(currentDate, todaysDate)
    }
    
    func test_getHourFrom() {
        let timeStamp = 1625382000
        let date = Date(timeIntervalSince1970: Double(timeStamp))
        let expectedTime = "12:30 PM"
        let result = Date.getHourFrom(date: date)
        XCTAssertEqual(expectedTime, result)
    }
    
    func test_getDayOfWeekFrom() {
        let timeStamp = 1625382000
        let date = Date(timeIntervalSince1970: Double(timeStamp))
        let expectedDate = "July 4"
        let result = Date.getDayOfWeekFrom(date: date)
        XCTAssertEqual(expectedDate, result)
    }
    
    func test_TeperatureConversion() {
        let kelvinTemp = 301.20
        let expectedCelsius = 28.0
        let expectedFahrenheit = 82.0
        XCTAssertEqual(expectedCelsius, kelvinTemp.celsius.rounded())
        XCTAssertEqual(expectedFahrenheit, kelvinTemp.fahrenheit.rounded())
        
    }
}
