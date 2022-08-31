//
//  PersonAPIManager.swift
//  SeSAC_iOS_Week9_URLSession
//
//  Created by 한상민 on 2022/08/30.
//

import Foundation



class PersonAPIManager {
    static func requestPerson(query: String, completion: @escaping (Person?, APIError?) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/search/person?api_key=27e079b699b4fa924f7f0200da266236&language=en-US&query=\(query)&page=1&include_adult=false&region=ko-KR")!
        let scheme = "https"
        let host = "api.themoviedb.org"
        let path = "/3/search/person"
        
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.path = path
        component.queryItems = [
            URLQueryItem(name: "api_key", value: "27e079b699b4fa924f7f0200da266236"),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "region", value: "ko-KR")
        ]
        
//        URLSession.request(endpoint: .shared, completion: <#T##((Decodable & Encodable)?, APIError?) -> Void#>)
        
        URLSession.shared.dataTask(with: component.url!) { data, response, error in
            DispatchQueue.main.async {
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
                    let result = try JSONDecoder().decode(Person.self, from: data)
                    dump(result)
                    completion(result, nil)
                } catch {
                    print(error)
                    completion(nil, .invalidData)
                }
            }
        }.resume()
    }
}
