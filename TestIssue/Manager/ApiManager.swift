//
//  ApiManager.swift
//  TestIssue
//
//  Created by Роман Воробец on 16.03.2021.
//

import Foundation
import Alamofire

struct ApiManager {
    
    
    
    /*
    //===============================================
    static func getPhoneMask(ifSuccess: @escaping (String) -> (),
                             ifFail: @escaping () -> ())
    {
        let request = AF.request("http://dev-exam.l-tech.ru/api/v1/phone_masks",
                                 method: .get)
        request.responseJSON { data in
            switch data.result {
            case .success(let value):
                print(data.result)
                if let result = value as? [String: Any] {
                    if let phoneMask = result["phoneMask"] as? String {
                        ifSuccess(phoneMask)
                    }
                }
                break
                
            case .failure( _):
                ifFail()
                break
            }
        }
    }
    
    
    
    
    //===============================================
    static func postAuth(phone: String,
                         password: String,
                         ifSuccess: @escaping () -> (),
                         ifFail: @escaping () -> ())
    {
        let parameters: [String: String] = [
            "phone": phone,
            "password": password
        ]
        let request = AF.request("http://dev-exam.l-tech.ru/api/v1/auth",
                                 method: .post, parameters: parameters)
        request.responseJSON { data in
            switch data.result {
            case .success(let value):
                if let result = value as? [String: Any] {
                    if let success = result["success"] as? Bool {
                        if success == true {
                            ifSuccess()
                        } else {
                            ifFail()
                        }
                    }
                }
                
                break
            case .failure(let error):
                print(error)
                ifFail()
                break
            }
        }
    }
    
    
    */
    
    //===============================================
    static func getWarezList(ifSuccess: @escaping ([ProductModel]) -> (),
                             ifFail: @escaping () -> ())
    {
        let request = AF.request("http://dev-exam.l-tech.ru/api/v1/posts",
                                 method: .get)
        request.responseJSON { data in
            switch data.result {
            case .success(let value):
                if let result = value as? [String: Any] {
                    if let success = result["success"] as? Bool {
                        if success == true {
//                            ifSuccess(result)
                        } else {
//                            ifFail()
                        }
                    }
                }
                
                break
            case .failure(let error):
                print(error)
                ifFail()
                break
            }
        }
    }
    
    
    
    
    //===============================================
    static func getImage(imageUrl: String,
                         ifSuccess: @escaping () -> (),
                         ifFail: @escaping () -> ())
    {
        let request = AF.request(imageUrl,
                                 method: .get)
        request.responseJSON { data in
            switch data.result {
            case .success(let value):
                if let result = value as? [String: Any] {
                    if let success = result["success"] as? Bool {
                        if success == true {
                            ifSuccess()
                        } else {
                            ifFail()
                        }
                    }
                }
                
                break
            case .failure(let error):
                print(error)
                ifFail()
                break
            }
        }
    }
    
    
    
    
    //===============================================
}
