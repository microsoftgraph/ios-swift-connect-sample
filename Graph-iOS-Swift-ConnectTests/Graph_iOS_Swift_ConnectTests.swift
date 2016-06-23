//
//  Graph_iOS_Swift_ConnectTests.swift
//  Graph-iOS-Swift-ConnectTests
//
//  Created by Jason Kim on 6/22/16.
//  Copyright © 2016 Jason Kim. All rights reserved.
//

import XCTest
import UIKit
@testable import Graph_iOS_Swift_Connect

class Graph_iOS_Swift_ConnectTests: XCTestCase {
    
    var graphClient: MSGraphClient?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        if graphClient == nil {
            print("Create client")
            MSGraphClient.setAuthenticationProvider(testAuthProvider())
            graphClient = MSGraphClient.defaultClient()
        }
        else {
            print("Load client - client already created")
        }

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    // check for creation of message
    func testCreateMailMessage() {
        

        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc = storyboard.instantiateViewControllerWithIdentifier("SendViewController") as! SendViewController
        let message = vc.createSampleMessage(to: "test@samplemail")

        XCTAssertNotNil(message)
    }
    
    func testAuthentication() {
        // Declare our expectation
        var readyExpectation = expectationWithDescription("ready")
        
        let request: MSGraphUserRequest = (graphClient?.me().request())!
            
        request.getWithCompletion({ (user: MSGraphUser?, error: NSError?) in
            
            print("user", user!)
            
            
            readyExpectation.fulfill()
            })
        
        waitForExpectationsWithTimeout(50) { (error: NSError?) in
            XCTAssertNil(error, "Error")
            return
        }
        
        
        readyExpectation = expectationWithDescription("again")
        
        request.getWithCompletion({ (user: MSGraphUser?, error: NSError?) in
            
            print("user", user!)
            
            
            readyExpectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(50) { (error: NSError?) in
            XCTAssertNil(error, "Error")
            return
        }
        
        
        
    }
}


