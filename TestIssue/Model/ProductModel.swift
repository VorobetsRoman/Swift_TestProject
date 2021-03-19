//
//  ProductModel.swift
//  TestIssue
//
//  Created by Роман Воробец on 17.03.2021.
//

import Foundation

struct ProductModel {
//    var id: String
    var title: String
    var text: String
    var image: String
    var sort: Int
    var date: String
    var imageData: Data
    
    init(jsonDic : NSDictionary) {
//        self.id = ((jsonDic["id"] != nil) ? jsonDic["id"] as? String : nil)!
        self.title = (jsonDic["title"] != nil ? jsonDic["title"] as? String : nil)!
        self.text = (jsonDic["text"] != nil ? jsonDic["text"] as? String : nil)!
        self.image = (jsonDic["image"] != nil ? jsonDic["image"] as? String : nil)!
        self.sort = (jsonDic["sort"] != nil ? jsonDic["sort"] as? Int : nil)!
        self.date = (jsonDic["date"] != nil ? jsonDic["date"] as? String : nil)!
        self.imageData = Data()
    }
    
    
}
