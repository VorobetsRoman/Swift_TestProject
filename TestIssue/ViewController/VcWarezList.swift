//
//  VcWarezList.swift
//  TestIssue
//
//  Created by Роман Воробец on 16.03.2021.
//

import UIKit
import Alamofire

class VcWarezList: UITableViewController {
    var m_productList: [ProductModel] = [] ///< list for information about products
    var m_imagesList: [UIImage] = [] ///< list for images
    
    enum Sorting {
        case server
        case time
    }
    var m_sorting = Sorting.server
    
    //===============================================
    override func viewDidLoad() {
        super.viewDidLoad()

        getWarez()
    }

    
    
    // MARK: - Table view data source
    //===============================================
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isViewLoaded {
            return 1
        }
        return 0
    }
    
    
    
    
    //===============================================
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        if isViewLoaded {
            return m_productList.count + 1
        }
        return 0
    }
    
    
    
    
    //===============================================
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sortCell", for: indexPath)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "warezCell", for: indexPath) as! CellWarezList
            let product = m_productList[indexPath.row - 1]
            cell.ui_cellTime.text = product.date
            cell.ui_cellTitle.text = product.title
            cell.ui_cellDettext.text = product.text
            if let image = UIImage.init(data: product.imageData) {
                cell.ui_cellImage.image = image
            }
            return cell
        }
    }
    
    
    
    
    //===============================================
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    //MARK: DataReciving
    //===============================================
    func getWarez () {
        AF.request("http://dev-exam.l-tech.ru/api/v1/posts", method: .get).responseJSON {
            response in
            switch response.result {
            case .success:
                if let objJson = response.value as! NSArray? {
                    for element in objJson {
                        let data = element as! NSDictionary
                        if let id = data["id"] as? String {
                            print(id)
                        }
                        let product = ProductModel(jsonDic: data)
                        print(product.title)
                        self.m_productList.append(product)
                    }
                }
                
                self.tableView.reloadData()
                self.getImage(productId: 0)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    
    

    //===============================================
    func getImage(productId: Int) {
        AF.request("http://dev-exam.l-tech.ru" + m_productList[productId].image).responseData {
            response in
            if case .success(let image) = response.result {
                self.m_productList[productId].imageData = image
//                let uiImage = UIImage.init(data: image)
                let cellIndex = productId + 1
//                let cell = self.tableView.cellForRow(at: IndexPath.init(row: cellIndex, section: 0)) as! CellWarezList
//                cell.ui_cellImage.image = uiImage
                
                if cellIndex < (self.m_productList.count - 1) {
                    self.getImage(productId: cellIndex)
                } else {
                    self.tableView.reloadData()
                }
//                break
//            case .failure(let error):
//                print(error)
//                break
            }
        }
    }
    
    
    
    
    //===============================================
    
}
