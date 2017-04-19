/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */


import Foundation

struct ApplicationConstants {
    static let clientId = "a0e7299f-1097-4c9a-a5e9-bf6376ae1a0b"
    static let scopes   = ["openid", "profile", "Mail.ReadWrite","mail.send","Files.ReadWrite","User.ReadBasic.All"]
}


/**
 Simple construct to encapsulate NSError. This could be expanded for more types of graph errors in future. 
 */
enum MSGraphError: Error {
    case nsErrorType(error: NSError)

}
