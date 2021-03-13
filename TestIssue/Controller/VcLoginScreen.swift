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
    
    override func viewWillAppear(_ animated: Bool) {

        let request = AF.request("http://dev-exam.l-tech.ru/api/v1/phone_masks", method: .get)
        request.responseJSON { (data) in
            switch data.result {
            case .success(let value):
                print(data.result)
                if let result = value as? [String: Any] {
                    if let phoneMask = result["phoneMask"] as? String {
                        print(phoneMask)
                    }
                }
        
            case .failure(let error):
                print(error)
            }
        }
        
        ui_tfPhone.delegate = self
    }

    @IBAction func ui_btSignin_tui(_ sender: UIButton) {
        performSegue(withIdentifier: "loginToLibrary", sender: Any?.self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
   
    func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "## ### ###"
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "#" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = formattedNumber(number: newString)
        return false
    }
    
}
