//
//  RequestManager.swift
//  3alsari3
//
//  Created by Mohamad Tarek on 3/6/19.
//  Copyright © 2019 Al-Youm-Host. All rights reserved.
//

import Foundation

enum NetworkResponseError: Error {
    case unacceptableStatusCode
    case noData
    case unableToDecode
}


struct APIResponse<T: Decodable>: Decodable {
    let success: Bool
    let data: T?
    let error: String?
}

/// Responsible for making any network requests
class RequestManager {
    
    static let shared = RequestManager()
    
    private init() {
    }
    
    // TODO: - Divide into smaller functions
    func performRequest<T: Decodable, TargetType: EndpointType>(withRoute route: TargetType, responseModel model: T.Type, andDecoder decoder: JSONDecoder = JSONDecoder(), andCompletionHandler completion: @escaping (Result<T, Error>) -> ()) {
        
        let router = Router<TargetType>()
        
        router.request(route) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    return
                }
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(.failure(NetworkResponseError.noData))
                        return
                    }
                    do {
                        // TODO: Parsing manager
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let parsedData = try JSONDecoder().decode(APIResponse<T>.self, from: responseData)
                        guard parsedData.success, let data = parsedData.data else {
                            let errorMessage = parsedData.error ?? "Generic error message" // TODO: Use constants
                            let error = NSError(domain: "", code: response.statusCode ,userInfo: [NSLocalizedDescriptionKey: errorMessage])
                            completion(.failure(error))
                            return
                        }
                        completion(.success(data))
                    } catch {
                        print(error)
                        completion(.failure(NetworkResponseError.unableToDecode))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Any, NetworkResponseError> {
        switch response.statusCode {
        case 200...299: return .success(response)
        default: return .failure(.unacceptableStatusCode)
        }
    }
    
}



