//
//  PersonModel.swift
//  SeSAC_iOS_Week9_URLSession
//
//  Created by 한상민 on 2022/08/30.
//

import Foundation

struct Person: Codable {
    let page, totalPages, totalResults: Int
    let results: [Result]
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
}

struct Result: Codable {
    let knownForDepartment, name: String
    
    enum CodingKeys: String, CodingKey { // 커스텀 키 맵핑
        case knownForDepartment = "known_for_department"
        case name
    }
}
