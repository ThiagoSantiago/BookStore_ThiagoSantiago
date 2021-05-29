//
//  BookStoreApiRequest.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 29/05/21.
//

import Foundation

protocol BookStoreApiRequestProtocol {
    func request(_ request: BookStoreApiSetupProtocol, completion: @escaping (Result<Data, BookStoreApiError>) -> Void)
}

final class BookStoreApiRequest: BookStoreApiRequestProtocol {
    
    func request(_ request: BookStoreApiSetupProtocol, completion: @escaping (Result<Data, BookStoreApiError>) -> Void) {
        var  jsonData = NSData()
        
        guard let urlRequest = URL(string: request.endpoint) else {
            completion(.failure(.badUrl))
            return
        }
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: request.parameters, options: .prettyPrinted) as NSData
        } catch {
            completion(.failure(.brokenData))
        }
        
        var requestData = URLRequest(url: urlRequest)
        requestData.httpMethod = request.method.rawValue
        requestData.allHTTPHeaderFields = request.headers
        if !request.parameters.isEmpty {
            requestData.httpBody = jsonData as Data
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: requestData) { (data, response, error) in
            
            if let error = error {
                completion(.failure(.unknown(error.localizedDescription)))
            }
            
            guard let data = data else {
                completion(.failure(.brokenData))
                return
            }
            
            if let returnData = String(data: data, encoding: .utf8) {
                print(returnData)
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknown("Could not cast to HTTPURLResponse object.")))
                return
            }
            
            completion(self.handler(statusCode: httpResponse.statusCode, dataResponse: data))
            
            }
            task.resume()
    }
    
    private func handler(statusCode: Int, dataResponse: Data) -> Result<Data, BookStoreApiError> {
        
        switch statusCode {
        case 200...299:
            return Result.success(dataResponse)
        case 403:
            return Result.failure(.authenticationRequired)
            
        case 404:
            return Result.failure(.couldNotFindHost)
            
        case 500:
            return Result.failure(.badRequest)
            
        default: return Result.failure(.unknown(""))
        }
    }
}
