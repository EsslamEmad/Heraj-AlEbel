//
//  MultipartDataEncoder.swift
//  3alsari3
//
//  Created by Mohamad Tarek on 5/6/19.
//  Copyright © 2019 Al-Youm-Host. All rights reserved.
//

import Foundation

public struct MultipartFormData {
    
    public let data: Data
    public let fileName: String
    
}

public struct MultipartDataEncoder {
    
    static func encode(urlRequest: inout URLRequest, with multipartFormData: MultipartFormData) {
        let boundary = UUID().uuidString
        let fullData = photoDataToFormData(data: multipartFormData.data, boundary: boundary, fileName: multipartFormData.fileName)
        
        urlRequest.setValue("multipart/form-data; boundary=" + boundary,
                         forHTTPHeaderField: "Content-Type")
        
        urlRequest.setValue(String(fullData.count), forHTTPHeaderField: "Content-Length")
        
        urlRequest.httpBody = fullData
        urlRequest.httpShouldHandleCookies = false
    }
    
    static func photoDataToFormData(data: Data, boundary: String, fileName: String) -> Data {
        var fullData = Data()
        let lineOne = "--" + boundary + "\r\n"
        fullData.append(lineOne.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        let lineTwo = "Content-Disposition: form-data; name=\"image\"; filename=\"" + fileName + "\"\r\n"
        NSLog(lineTwo)
        fullData.append(lineTwo.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        let lineThree = "Content-Type: image/jpg\r\n\r\n"
        fullData.append(lineThree.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        fullData.append(data)
        let lineFive = "\r\n"
        fullData.append(lineFive.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        let lineSix = "--" + boundary + "--\r\n"
        fullData.append(lineSix.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        return fullData
    }
    
    
}

