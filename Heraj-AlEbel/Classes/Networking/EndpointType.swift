//
//  EndpointType.swift
//  TheD. Gmbh Task
//
//  Created by Mohamad Tarek on 31/5/19.
//  Copyright © 2019 tarek. All rights reserved.
//

import Foundation

/// The protocol used to define the specifications necessary for a provider
protocol EndpointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
