/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */


import Foundation

struct ApplicationConstants {
    static let clientId = "ENTER_YOUR_CLIENT_ID"
    static let scopes   = ["https://graph.microsoft.com/Mail.Send", "https://graph.microsoft.com/User.Read", "offline_access"]
}


/**
 Simple construct to encapsulate NSError. This could be expanded for more types of graph errors in future. 
 */
enum MSGraphError: ErrorType {
    case NSErrorType(error: NSError)

}