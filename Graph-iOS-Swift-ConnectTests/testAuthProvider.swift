//
//  testAuthProvider.swift
//  Graph-iOS-Swift-Connect
//
//  Created by Jason Kim on 6/23/16.
//  Copyright © 2016 Jason Kim. All rights reserved.
//

import UIKit

@testable import Graph_iOS_Swift_Connect

class testAuthProvider: NSObject, MSAuthenticationProvider {
    
    var accessToken: String = ""
    
    let contentType           = "application/x-www-form-urlencoded"
    let grantType             = "password"
    let tokenEndPoint         = "https://login.microsoftonline.com/common/oauth2/token"
    let requestType           = "POST"
    let resourceId            = "https://graph.microsoft.com"

    let tokenType             = "bearer"
    let apiHeaderAuthrization = "Authorization"

    @objc func appendAuthenticationHeaders(_ request: NSMutableURLRequest!, completion completionHandler: MSAuthenticationCompletion!) {
        
        if accessToken != "" {
            let oauthAuthorizationHeader = String(format: "%@ %@", tokenType, accessToken)
            request.setValue(MS_API_HEADER_AUTHORIZATION, forHTTPHeaderField: oauthAuthorizationHeader)
            completionHandler(request, nil)
        }
        else {
            let path = Bundle(for: type(of: self)).path(forResource: "testUserArgs", ofType: "json")
            
            let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
            let jsonResult = try! JSONSerialization.jsonObject(with: jsonData, options: []) as! NSDictionary
            
            let username = jsonResult["test.username"] as! String
            let password = jsonResult["test.password"] as! String
            let clientId = jsonResult["test.clientId"] as! String
            
            let authRequest = NSMutableURLRequest()
            let bodyString = "grant_type=\(grantType)&resource=\(resourceId)&client_id=\(clientId)&username=\(username)&password=\(password)"
            
            authRequest.url = URL(string: tokenEndPoint)
            authRequest.httpMethod = requestType
            authRequest.setValue(contentType, forHTTPHeaderField: "Content_Type")
            authRequest.httpBody = bodyString.data(using: String.Encoding.utf8)
            
            let session = URLSession.shared
            let task = session.dataTask(with: authRequest, completionHandler: { (data: Data?, response: URLResponse?, error: NSError?) in
                
                if let validData = data {
                    let jsonDictionary = try! JSONSerialization.jsonObject(with: validData, options: .allowFragments) as! NSDictionary
                    if let accessTokenReturned = jsonDictionary["access_token"] {
                        self.accessToken = accessTokenReturned as! String
                    }
                    else {
                        self.accessToken = "WRONG_TOKEN"
                    }
                }
                
                let oauthAuthorizationHeader = String(format: "%@ %@", self.tokenType, self.accessToken)
                request.setValue(oauthAuthorizationHeader, forHTTPHeaderField: self.apiHeaderAuthrization)

                completionHandler(request, error)
            })
            task.resume()
        }
    }
}
