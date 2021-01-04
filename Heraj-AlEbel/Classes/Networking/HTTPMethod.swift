//
//  HTTPMethod.swift
//  TheD. Gmbh Task
//
//  Created by Mohamad Tarek on 31/5/19.
//  Copyright © 2019 tarek. All rights reserved.
//

import Foundation

/// HTTP method definitions.
///
/// See https://tools.ietf.org/html/rfc7231#section-4.3
public enum HTTPMethod : String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
