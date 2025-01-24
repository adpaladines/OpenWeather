//
//  WeatherRepositoryTests.swift
//  OpenWeather
//
//  Created by andres paladines on 1/20/25.
//

import XCTest
import Combine
@testable import OpenWeather

class WeatherServiceTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []
    private var mockServiceManager: MockServiceManager!
    private var repository: WeatherRepository!

    override func setUp() {
        super.setUp()
        mockServiceManager = MockServiceManager()
        repository = WeatherRepository(serviceManager: mockServiceManager)
        
        // Set a mock API key in UserDefaults
        UserDefaults.standard.set("mock_api_key", forKey: "api_key_selected")
    }

    override func tearDown() {
        // Clear mock API key
        UserDefaults.standard.removeObject(forKey: "api_key_selected")

        cancellables.removeAll()
        mockServiceManager = nil
        repository = nil
        super.tearDown()
    }

    // MARK: - Tests

    func test_getCurrentWeatherCombine_noCoordinates_shouldReturnError() {
        // Arrange
        repository.lat = nil
        repository.lon = nil

        // Act & Assert
        let expectation = self.expectation(description: "Should return error for missing coordinates")
        repository.getCurrentWeatherCombine()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error as? NetworkError, NetworkError.request)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Should not return a value")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func test_getCurrentWeatherCombine_missingApiKey_shouldReturnError() {
        // Arrange
        UserDefaults.standard.removeObject(forKey: "api_key_selected")
        repository.lat = "37.7749"
        repository.lon = "-122.4194"

        // Act & Assert
        let expectation = self.expectation(description: "Should return error for missing API key")
        repository.getCurrentWeatherCombine()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error as? NetworkError, NetworkError.dataNotFound)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Should not return a value")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func test_getCurrentWeatherCombine_validResponse_shouldReturnWeatherData() {
        // Arrange
        repository.lat = "37.7749"
        repository.lon = "-122.4194"

        // Act & Assert
        let expectation = self.expectation(description: "Should return valid weather data")
        repository.getCurrentWeatherCombine()
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Should not fail")
                }
            }, receiveValue: { weatherData in
                XCTAssertNotNil(weatherData)
                XCTAssertEqual(weatherData?.main.temp, 298.48)
                XCTAssertEqual(weatherData?.main.humidity, 64)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func test_getCurrentWeatherCombine_invalidResponse_shouldReturnParsingError() {
        // Arrange
        mockServiceManager.status = .parsingError
        repository.lat = "37.7749"
        repository.lon = "-122.4194"

        // Act & Assert
        let expectation = self.expectation(description: "Should fail with parsing error")
        repository.getCurrentWeatherCombine()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error as? NetworkError, NetworkError.parsingValue)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Should not return a value")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }
}
