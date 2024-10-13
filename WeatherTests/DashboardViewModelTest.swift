//
//  DashboardViewModelTest.swift
//  WeatherTests
//
//  Created by Sharath on 12/10/24.
//

import XCTest
import Combine
import CoreLocation


final class DashboardViewModelTest: XCTestCase {

    var viewModel: DashboardViewModel!
    var mockNetworkManager: MockNetworkManager!
//    var mockPersistenceManager: MockPersistenceManager!
    var cancellables: Set<AnyCancellable>!

    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockNetworkManager = MockNetworkManager()
//        mockPersistenceManager = MockPersistenceManager()
        viewModel = DashboardViewModel()
        cancellables = Set<AnyCancellable>()

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        mockNetworkManager = nil
//        mockPersistenceManager = nil
        cancellables = nil

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // Test to check if weather report is fetched successfully
    func testFetchWeatherReportSuccess() {
        let expectation = self.expectation(description: "Fetch weather report should return data")
        
        // Mocking the network call
        mockNetworkManager.mockResult = .success(WeatherResponse.mock())
        viewModel.fetchWeatherReport(endpoint: Endpoint.weatherReport(lat: 59.3293, lon: 18.0686))
        
        viewModel.$weather
            .sink { weather in
                if let weather {
                    XCTAssertEqual(weather.name, "Stockholm")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
        
    // Test to check if location permission is granted
    func testLocationPermissionGranted() {
        let expectation = self.expectation(description: "Location permission granted should trigger location update")
        
        if CLLocationManager().authorizationStatus == .authorizedWhenInUse {
            
            viewModel.$isLoading
                .sink { isLoading in
                    if !isLoading {
                        expectation.fulfill()
                    }
                }
                .store(in: &cancellables)
            
            wait(for: [expectation], timeout: 2.0)
        }
    }
    
    // Test to check if search result selection works
    func testSelectLocation() {
        let expectation = self.expectation(description: "Selecting a location should update search query and fetch weather")
        
        let location = GeoCode.init(
            name: "Stockholm",
            localNames: [:],
            lat: 59.3293,
            lon: 18.0686,
            country: "Sweden",
            state: "Sweden"
        )
        viewModel.selectLocation(location: location)
        
        viewModel.$searchQuery
            .sink { query in
                XCTAssertEqual(query, "Stockholm")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
}
