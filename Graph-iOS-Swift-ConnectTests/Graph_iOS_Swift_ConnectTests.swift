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
    
    var graphClient: MSGraphClient!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        MSGraphClient.setAuthenticationProvider(testAuthProvider())
        graphClient = MSGraphClient.defaultClient()
  
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // check for creation of message
    func testCreateMailMessage() {

        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc = storyboard.instantiateViewControllerWithIdentifier("SendViewController") as! SendViewController
        let message = vc.createSampleMessage(to: "test@samplemail")

        XCTAssertNotNil(message)
    }
    
    // check for getting user information: GET ME
    func testGetUserInformation() {
        let readyExpectation = expectationWithDescription("ready")
        graphClient.me().request().getWithCompletion({ (user: MSGraphUser?, error: NSError?) in
            XCTAssertNotNil(user, "User data should not be nil")
            XCTAssertNil(error, "Error should be nil")
            
            readyExpectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(10) { (error: NSError?) in
            XCTAssertNil(error, "Timeout")
            return
        }
    }
    
    
    // check sending mail
    func testAuthentication() {

        // get email address
        let path = NSBundle(forClass: self.dynamicType).pathForResource("testUserArgs", ofType: "json")
        
        let jsonData = try! NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe)
        let jsonResult = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! NSDictionary
        
        let username = jsonResult["test.username"] as! String
        XCTAssertNotNil(username, "username should not be nil")
        
        // get message
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let vc = storyboard.instantiateViewControllerWithIdentifier("SendViewController") as! SendViewController
        let message = vc.createSampleMessage(to: username)
        XCTAssertNotNil(message, "message should not be nil")
        
        // send mail
        let readyExpectation = expectationWithDescription("ready")
        
        graphClient.me().sendMailWithMessage(message, saveToSentItems: false).request().executeWithCompletion({
            (response: [NSObject : AnyObject]?, error: NSError?) in
            
            XCTAssertNotNil(response, "response should not be nil")
            XCTAssertNil(error, "Error should be nil")
            
            readyExpectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(10) { (error: NSError?) in
            XCTAssertNil(error, "Timeout")
            return
        }
    }
}


