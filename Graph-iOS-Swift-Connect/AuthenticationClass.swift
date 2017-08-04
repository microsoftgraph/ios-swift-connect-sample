//
//  AuthenticationClass.swift
//  Graph-iOS-Swift-Connect

import Foundation
import MSAL

class AuthenticationClass {
    
    var authenticationProvider = MSALPublicClientApplication.init()
    
    init (clientId: String, authority: String) {
        do {
            authenticationProvider = try MSALPublicClientApplication.init(clientId: clientId, authority: authority)
        } catch  _  {
            authenticationProvider = MSALPublicClientApplication.init()
        }
    }
    /**
     Authenticates to Microsoft Graph.
     If a user has previously signed in before and not disconnected, silent log in
     will take place.
     If not, authentication will ask for credentials
     */
    func connectToGraph(withClientId clientId: String,
                        scopes: [String],
                        completion:@escaping (_ error: MSGraphError?, _ accessToken: String) -> Void)  {
        
        var accessToken = String()
        do {
            
            // We check to see if we have a current logged in user. If we don't, then we need to sign someone in.
            // We throw an interactionRequired so that we trigger the interactive signin.
            
            if  try authenticationProvider.users().isEmpty {
                throw NSError.init(domain: "MSALErrorDomain", code: MSALErrorCode.interactionRequired.rawValue, userInfo: nil)
            } else {
                
                // Acquire a token for an existing user silently
                
                try authenticationProvider.acquireTokenSilent(forScopes: scopes, user: authenticationProvider.users().first) { (result, error) in
                    
                    if error == nil {
                        accessToken = (result?.accessToken)!
                        //self.getContentWithToken(withAccessToken: accessToken)
                        completion(nil, accessToken);
                        
                        
                    } else {
                        
                        //"Could not acquire token silently: \(error ?? "No error information" as! Error )"
                        completion(MSGraphError.nsErrorType(error: error! as NSError), "");
                        
                    }
                }
            }
        }  catch let error as NSError {
            
            // interactionRequired means we need to ask the user to sign-in. This usually happens
            // when the user's Refresh Token is expired or if the user has changed their password
            // among other possible reasons.
            
            if error.code == MSALErrorCode.interactionRequired.rawValue {
                
                authenticationProvider.acquireToken(forScopes: scopes) { (result, error) in
                    if error == nil {
                        accessToken = (result?.accessToken)!
                        completion(nil, accessToken);
                        
                        
                    } else  {
                        completion(MSGraphError.nsErrorType(error: error! as NSError), "");
                        
                    }
                }
                
            }
            
        } catch {
            
            // This is the catch all error.
            
            
            completion(MSGraphError.nsErrorType(error: error as NSError), error.localizedDescription);
            
        }
    }
    func disconnect() {
        
        do {
            try authenticationProvider.remove(authenticationProvider.users().first)
            
        } catch _ {
            
        }
        
    }

}
