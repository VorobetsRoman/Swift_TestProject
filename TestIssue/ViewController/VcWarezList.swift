//
//  VcWarezList.swift
//  TestIssue
//
//  Created by Роман Воробец on 16.03.2021.
//

import UIKit
import Alamofire


enum Sorting {
    case server
    case time
}


protocol SortingDelegate: class {
    func setSortingType(sortingType: Sorting)
}


class VcWarezList: UITableViewController, SortingDelegate {
    
    var m_productList: [ProductModel] = [] ///< list for information about products
    var m_sorting = Sorting.server
    
    
    
    
    //===============================================
    override func viewDidLoad() {
        super.viewDidLoad()

        getWarez()
    }

    
    
    // MARK: - Table view delegate
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
            if let sortCell = cell as? CellSortSelection {
                sortCell.delegate = self
            }
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
    
    
    
    
    //===============================================
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "WarezToCell", sender: tableView.cellForRow(at: indexPath))
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
                self.sortList()
                
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
            }
            
            if productId < (self.m_productList.count - 1) {
                self.getImage(productId: productId + 1)
            } else {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    
    //===============================================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "WarezToCell" else {return}
        guard let destination = segue.destination as? VcWarezDesc else {return}
        if let cell = sender as? UITableViewCell {
            let index = tableView.indexPath(for: cell)!.row - 1
            destination.m_desc = m_productList[index].text
            destination.m_title = m_productList[index].title
            destination.m_imageData = m_productList[index].imageData
        }
    }
    
    
    
    
    //===============================================
    func sortList() {
        if self.m_sorting == .server {
            self.m_productList.sort{$0.sort > $1.sort}
        } else {
            self.m_productList.sort{$0.date > $1.date}
        }
    }
    
    
    
    
    //===============================================
    func setSortingType(sortingType: Sorting) {
        m_sorting = sortingType
        print(sortingType)
        self.tableView.reloadData()
    }
    
    
    
    
    //===============================================
}
