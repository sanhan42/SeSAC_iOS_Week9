//
//  URLSession+Extention.swift
//  SeSAC_iOS_Week9_URLSession
//
//  Created by 한상민 on 2022/08/30.
//

import Foundation

extension URLSession {
    typealias completionHandler = (Data?, URLResponse?, Error?) -> Void
    
    @discardableResult
    func customDataTask(_ endpoint: URLRequest, completionHandler: @escaping completionHandler) -> URLSessionDataTask {
        let task = dataTask(with: endpoint, completionHandler: completionHandler)
        task.resume()
        return task
    }
    
    static func request<T: Codable>(_ session: URLSession = .shared, endpoint: URLRequest, completion: @escaping (T?, APIError?)->Void) {
        session.customDataTask(endpoint) { data, response, error in
            guard error == nil else {
                print("Failed Request")
                completion(nil,.failedRequest)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Unable Response")
                completion(nil, .invalidResponse)
                return
            }
            
            guard response.statusCode == 200 else {
                print("Failed Response")
                completion(nil, .failedRequest)
                return
            }
            
            guard let data = data else {
                print("No Data Returned")
                completion(nil, .noData)
                return
            }

            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                dump(result)
                completion(result, nil)
            } catch {
                print(error)
                completion(nil, .invalidData)
            }
        }
    }
}
