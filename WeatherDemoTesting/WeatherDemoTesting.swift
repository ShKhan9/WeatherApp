//
//  WeatherDemoTesting.swift
//  WeatherDemoTesting
//
//  Created by MacBook Pro on 9/4/21.
//

import XCTest
@testable import WeatherDemo
class WeatherForecastTests: XCTestCase {
  
    let vm = WeatherVM()
     
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    // test that server returns a valid value when you supply the parameter correctly
    func testRemoteCall() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let exp = expectation(description: "Server fetch")
       
        vm.getWeatherData(for:"London") { res in
        
            XCTAssertNotNil(res,"Invalid server response")
              
            exp.fulfill()
        }
      
        waitForExpectations(timeout: 10.0) { error in
            
            print(error as Any)
        
        }
         
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

