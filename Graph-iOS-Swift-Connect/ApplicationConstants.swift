/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */


import Foundation

struct ApplicationConstants {
    static let clientId = "Enter_Client_Id_Here"
    static let scopes   = ["mail.send","Files.ReadWrite","User.ReadBasic.All"]
}


/**
 Simple construct to encapsulate NSError. This could be expanded for more types of graph errors in future. 
 */
enum MSGraphError: Error {
    case nsErrorType(error: NSError)

}
