//
//  LottoAPIManager.swift
//  SeSAC_iOS_Week9_Lotto
//
//  Created by 한상민 on 2022/08/30.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case noData
    case failedRequest
    case invalidData
}

class LottoAPIManager {
    static func requestLotto(drwNo: Int, completion: @escaping (Lotto?, APIError?) -> Void) {
/* // default configuration - shared와 유사, 커스텀 가능, (셀룰러 연결 여부, 타임 아웃 간격 등등), 응답을 클로저 또는 딜리게이트로 처리.
//        URLSession.init(configuration: .default)
//        URLSession.init(configuration: .ephemeral)
//        URLSession.init(configuration: .background(withIdentifier: <#T##String#>))
*/
        let url = URL(string: "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(drwNo)")!
//        헤더 이용 - URLRequest
//        let a = URLRequest(url: url)
//        a.setValue(<#T##value: String?##String?#>, forHTTPHeaderField: <#T##String#>)
        
        // Shared - 단순. 커스텀X, 응답은 클로저로 전달, 백그라운드 전동은 불가.
        URLSession.shared.dataTask(with: url) { data, response, error in
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

    //            dump(String(data: data, encoding: .utf8))
                do {
                    let result = try JSONDecoder().decode(Lotto.self, from: data)
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
