//
//  OpenWeatherTests.swift
//  OpenWeatherTests
//
//  Created by andres paladines on 10/25/23.
//

import XCTest
import CoreLocation
import SwiftUI

@testable import OpenWeather

final class OpenWeatherTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_Throws_UrlError() async throws {
        let expectation = XCTestExpectation(description: "Async function should throw a bad Url error.")
        
        let lat = 33.753746
        let lon = -84.386330
        let repo = WeatherRepository()
        let networkmanager = JsonManager()
        
        repo.setServiceManager(networkmanager, and: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        do {
            _ = try await repo.getCurrentWeather(testingPath: "@")
        } catch {
            guard let myError = error as? NetworkError else { throw NSError() }
            XCTAssert(myError == NetworkError.invalidUrl)
            expectation.fulfill()
            await fulfillment(of: [expectation], timeout: 1, enforceOrder: true)
//            throw error
        }
    }
    
    func testGetCurrentWeatherInfo_WhenEverything_Goes_Correct() async throws {
        let expectation = XCTestExpectation(description: "Getting all the information from Json file")
        let expectRain = XCTestExpectation(description: "Json contains rain information.")
        let expectNotSnowfall = XCTestExpectation(description: "Json does not have snow information.")
        let lat = 33.753746
        let lon = -84.386330
        let repo = WeatherRepository()
        let networkmanager = JsonManager()
        
        repo.setServiceManager(networkmanager, and: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        do {
            let data = try await repo.getCurrentWeather()
            XCTAssertNotNil(data)
            let resp = data!
            XCTAssertGreaterThan(resp.main.temp, 32)
            expectation.fulfill()
            
            XCTAssertNotNil(resp.sys?.country)
            
            XCTAssertNotNil(resp.rain)
            expectRain.fulfill()
            
            XCTAssertNil(resp.snow)
            expectNotSnowfall.fulfill()
            
            await fulfillment(of: [expectation, expectRain, expectNotSnowfall], timeout: 1, enforceOrder: true)
        } catch {
            throw error
        }
    }

    func testGetForecastInfo_WhenEverything_Goes_Correct() async throws {
        let expectation = XCTestExpectation(description: "getting all the information from Json file")
        let lat = 33.753746
        let lon = -84.386330
        let repo = WeatherRepository()
        let networkmanager = JsonManager()
        
        repo.setServiceManager(networkmanager, and: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        do {
            let data = try await repo.getForecastData()
            XCTAssertNotNil(data)
            let resp = data!
            XCTAssertGreaterThan(resp.list.count, 0)
            XCTAssertEqual(resp.list.count, 40)
            XCTAssertEqual(resp.list.first?.weather.first?.description, "scattered clouds")

            expectation.fulfill()
            await fulfillment(of: [expectation], timeout: 1, enforceOrder: true)
        } catch {
            throw error
        }
    }

    func testGetForecastInfo_WhenEverything_Goes_Correct_ButNoData() async throws {
        let expectation = XCTestExpectation(description: "getting all the information from Json file")
        let lat = 33.753746
        let lon = -84.386330
        let repo = WeatherRepository()
        let networkmanager = JsonManager()
        
        repo.setServiceManager(networkmanager, and: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        do {
            let data = try await repo.getForecastData(testingPath: "forecast_empty")
            XCTAssertNotNil(data)
            let resp = data!
            XCTAssertEqual(resp.list.count, 0)
            expectation.fulfill()
            await fulfillment(of: [expectation], timeout: 1, enforceOrder: true)
        } catch {
            throw error
        }
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
