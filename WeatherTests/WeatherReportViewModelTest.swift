//
//  WeatherReportViewModelTest.swift
//  WeatherTests
//
//  Created by Sharath on 12/10/24.
//

import XCTest

final class WeatherReportViewModelTest: XCTestCase {

    private var viewModel: WeatherReportViewModel!

    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = WeatherReportViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testTemperatureConversionToCelsius() throws {
        // Test case for Celsius conversion
        viewModel.temperatureScale = .Celsius
        let tempInKelvin: Double = 278.79 // Example temperature in Kelvin
        let result = viewModel.temperature(value: tempInKelvin)
        XCTAssertEqual(result, "5 °C", "Temperature should be 5 °C for 278.79K")
    }

    func testTemperatureConversionWithNilValue() throws {
        // Test case when temperature value is nil
        viewModel.temperatureScale = .Celsius
        let result = viewModel.temperature(value: nil)
        XCTAssertEqual(result, "-- °C", "Should return -- °C when temperature is nil")
    }

    func testTimestampToDateConversion() throws {
        // Test case for timestamp to date conversion
        let timestamp: Double = 1728818083 // Example UNIX timestamp
        let result = viewModel.timestampToDate(timestamp: timestamp)
        
        // You need to adjust this expected result based on your local timezone
        let expectedTime = "4:44 PM" // Adjust as per your timezone (this is for UTC+0)
        XCTAssertEqual(result, expectedTime, "Formatted date should match expected time")
    }

}
