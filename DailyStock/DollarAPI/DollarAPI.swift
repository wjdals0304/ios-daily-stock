//
//  DollarAPI.swift
//  DailyStock
//
//  Created by 김정민 on 2021/12/27.
//

import Foundation

enum APIError : Error {
    case invalidResponse
    case noData
    case failed
    case invalidData
}

class DollarAPI {
    
    
    static func dollarPrice(completion: @escaping (Dollar? , APIError?) -> Void)  {
        
        
        let url = URL(string: "https://quotation-api-cdn.dunamu.com/v1/forex/recent?codes=FRX.KRWUSD")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.httpBody = Data() 
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                completion(nil,.failed)
                return
            }
            
            guard let data = data else {
                completion(nil,.noData)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(nil,.invalidResponse)
                return
            }
            
            guard response.statusCode == 200 else {
                completion(nil,.failed)
                return
            }
                        
            do {
                let decoder = JSONDecoder()
                let dollar = try decoder.decode(Dollar.self, from: data)
 
                completion(dollar,nil)
            } catch {
                completion(nil,.invalidData)
            }

        }.resume()
        
    }
    
    
    
}
