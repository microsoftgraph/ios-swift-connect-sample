/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */


import Foundation


struct ApplicationConstants {
    static let clientId = "3700a5ef-cee9-498e-a7e3-cbf701966331"
    static let scopes   = ["https://graph.microsoft.com/Mail.ReadWrite","https://graph.microsoft.com/mail.send","https://graph.microsoft.com/Files.ReadWrite","https://graph.microsoft.com/User.ReadBasic.All"]
    static let kAuthority = "https://login.microsoftonline.com/common/v2.0"
    static let kGraphURI = "https://graph.microsoft.com/v1.0/me/"

}


/**
 Simple construct to encapsulate NSError. This could be expanded for more types of graph errors in future. 
 */
enum MSGraphError: Error {
    case nsErrorType(error: NSError)

}

