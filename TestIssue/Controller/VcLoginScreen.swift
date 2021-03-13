//
//  VcLoginScreen.swift
//  TestIssue
//
//  Created by Роман Воробец on 12.03.2021.
//

import UIKit
import Alamofire

class VcLoginScreen: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var ui_tfPhone: UITextField!
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
//                            print(phoneMask)
                        }
                    }
                }
        
            case .failure(let error):
                print(error)
            }
        }
        ui_tfPhone.delegate = self
    }

    
    
    //===============================================
    @IBAction func ui_btSignin_tui(_ sender: UIButton) {
        performSegue(withIdentifier: "loginToLibrary", sender: Any?.self)
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
                if !number[index].isNumber { //пропускаем символ в номере
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
    
}
