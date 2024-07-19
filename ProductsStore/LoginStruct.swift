//
//  SendOtpStruct.swift
//  DMS
//
//  Created by Abhang Mane @Goldmedal on 08/07/24.
//  Copyright © 2024 Goldmedal. All rights reserved.
//

import Foundation
struct LoginElement: Codable {
    let Version: String?
    let StatusCode: Int?
    let StatusCodeMessage: String?
    let Timestamp: String?
    let Size: Int?
    let Data: [LoginData]?
    let Errors: [LoginErrors]?
}

struct LoginData: Codable {
    let OTP: String?
    let Mobile: String?
    let Message: String?
    let MasterUser: Bool?
}

struct LoginErrors:Codable {
    let ErrorCode: Int?
    let ErrorMsg: String?
    let Parameter: String?
    let HelpUrl: String?
}

struct LoginAPIManager {
    static func makeAPIRequest(params: [String:Any], completion: @escaping (Result<LoginElement, Error>) -> Void) {
        let urlString = ""
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        // Set the content type to JSON
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let string = String(decoding: data, as: UTF8.self)
                            print("OTPData\(string)")
                let Response = try decoder.decode(LoginElement.self, from: data)// try decoder.decode(LeadListInfo.self, from: data)
                completion(.success(Response))
            } catch {
                do {
                    let CommonOutputErrorElementMain = try JSONDecoder().decode([CommonOutputErrorElement].self, from: data)
                    
                    let status = CommonOutputErrorElementMain[0].message
                    DispatchQueue.main.async {
                        Utility.showAlertMsg(_title: "", _message: status ?? "Error", _cancelButtonTitle: "OK")
                    }
                } catch let errorData {
                    print(errorData)
                }
                completion(.failure(error))
            }
        }.resume()
    }
}

