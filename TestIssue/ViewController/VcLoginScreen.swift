//
//  VcLoginScreen.swift
//  TestIssue
//
//  Created by Роман Воробец on 12.03.2021.
//

import UIKit
import Alamofire

struct Credentials {
    var phonenumber: String
    var password: String
}

enum KeychainError: Error {
    case noPassword
    case unespectedPasswordData
    case unhadledError(status: OSStatus)
}

let appname = "TestIssue"

class VcLoginScreen: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var ui_tfPhone: UITextField!
    @IBOutlet weak var ui_tfPassword: UITextField!
    //    var phoneMaskSuffix = ""
    var phoneMaskPrefix = ""
    var phoneMask = ""
    
    
    
    //===============================================
    override func viewWillAppear(_ animated: Bool) {

        let request = AF.request("http://dev-exam.l-tech.ru/api/v1/phone_masks", method: .get)
        request.responseJSON { (data) in
            switch data.result {
            case .success(let value):
                print(data.result)
                if let result = value as? [String: Any] {
                    if let phoneMask = result["phoneMask"] as? String {
                        if let spaceIndex = phoneMask.firstIndex(of: " ") {
                            self.phoneMaskPrefix = String(phoneMask.prefix(through: spaceIndex))
                            self.ui_tfPhone.text = self.phoneMaskPrefix
//                            self.phoneMaskSuffix = String(phoneMask.suffix(from: spaceIndex))
                            self.phoneMask = phoneMask
                        }
                    }
                }
        
            case .failure(let error):
                print(error)
            }
        }
        ui_tfPhone.delegate = self
        
        let phoneKey = appname + "phone"
        let passKey = appname + "password"
        if let phoneData = KeyChain.load(key: phoneKey), let passData = KeyChain.load(key: passKey) {
//            let phone = phoneData.to(type: String.self)
//            let pass = passData.to(type: String.self)
            print("result: ", phoneData, passData)
        }
    }

    
    
    //===============================================
    @IBAction func ui_btSignin_tui(_ sender: UIButton) {
        guard let phone = ui_tfPhone.text, let password = ui_tfPassword.text else { return }
        let clearPhone = removeNonDigits(text: phone)
        let parameters: [String: String] = [
            "phone": clearPhone,
            "password": password
        ]
        let request = AF.request("http://dev-exam.l-tech.ru/api/v1/auth", method: .post, parameters: parameters)
        request.responseJSON { (data) in
            switch data.result {
            case .success(let value):
                if let result = value as? [String: Any] {
                    if let success = result["success"] as? Bool {
                        if success == true {
                            self.performSegue(withIdentifier: "loginToLibrary", sender: (Any).self)
                        }
                    }
                }
                //KeyChain
//                let phoneData = Data(from: phone)
                let phoneKey = appname + "phone"
                let phoneResult = KeyChain.save(key: phoneKey, string: phone)
                print(phoneResult)
//                let passData = Data(from: password)
                let passKey = appname + "password"
                let passResult = KeyChain.save(key: passKey, string: password)
                print(passResult)
                /*let account = clearPhone
                let kpassword = password.data(using: String.Encoding.utf8)
                let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                            kSecAttrAccount as String: account,
                                            kSecAttrServer as String: appname,
                                            kSecValueData as String: kpassword!]
                var ref: AnyObject?
                let status = SecItemAdd(query as CFDictionary, &ref)
                let result = ref as! Data
                print(status)
                let password = String(data: result, encoding: .utf8)!
                print("Password: \(password)")*/
                
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    
    
    //===============================================
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    // MARK: textFieldDelegate
    //===============================================
    func formattedNumber(number: String) -> String {
        var result = ""
        var index = number.startIndex
        
        for ch in self.phoneMask where index < number.endIndex {
            switch ch {
            case "+", "0", "1"..."9" : //проходим заголовок
                result.append(ch)
                index = number.index(after: index)
                break
            case "Х" : //если в маске цифра ищем следующую цифру в number
                while index < number.endIndex && !(number[index].isNumber) {
                    index = number.index(after: index)
                }
                if index < number.endIndex {
                    result.append(number[index])
                    index = number.index(after: index)
                }
                break
            default:
                result.append(ch)
                if !(number[index].isNumber) { //пропускаем символ в номере
                    index = number.index(after: index)
                }
                break
            }
        }
        
        if result.count < self.phoneMaskPrefix.count {
            result = self.phoneMaskPrefix
        }
        return result
    }
    
    
    
    //===============================================
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = formattedNumber(number: newString)
        return false
    }
    
    
    
    //===============================================
    func removeNonDigits( text: String) -> String {
        var result = ""
        for ch in text where ch.isNumber {
            result.append(ch)
        }
        return result
    }
    
}
