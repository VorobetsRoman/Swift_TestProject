//
//  VcLoginScreen.swift
//  TestIssue
//
//  Created by Роман Воробец on 12.03.2021.
//

import UIKit
import Alamofire

class VcLoginScreen: UIViewController {
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
    }

    @IBAction func ui_btSignin_tui(_ sender: UIButton) {
        performSegue(withIdentifier: "loginToLibrary", sender: Any?.self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
