//
//  VcWarezDesc.swift
//  TestIssue
//
//  Created by Роман Воробец on 19.03.2021.
//

import UIKit

class VcWarezDesc: UIViewController {
    @IBOutlet weak var ui_Image: UIImageView!
    @IBOutlet weak var ui_title: UILabel!
    @IBOutlet weak var ui_desc: UILabel!
    
    var m_imageData: Data!
    var m_title: String!
    var m_desc: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = m_imageData {
            ui_Image.image = UIImage.init(data: image)
        }
        if let title = m_title {
            ui_title.text = title
        }
        if let desc = m_desc {
            ui_desc.text = desc
        }
    }
}
