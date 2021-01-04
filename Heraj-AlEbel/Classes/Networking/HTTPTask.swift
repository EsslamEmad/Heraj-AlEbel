//
//  HTTPTask.swift
//  TheD. Gmbh Task
//
//  Created by Mohamad Tarek on 31/5/19.
//  Copyright © 2019 tarek. All rights reserved.
//

import Foundation

/// Represents HTTP headers
public typealias HTTPHeaders = [String: String]

/// Represents an HTTP task
public enum HTTPTask {
    
    /// A request with no additional data
    case requestPlain
    
    /// A requests body set with encoded parameters
    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    
    /// A requests body set with encoded parameters
    case uploadMultipart(data: Data,
        fileName: String)
    
}
