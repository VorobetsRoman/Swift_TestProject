//
//  CellSortSelection.swift
//  TestIssue
//
//  Created by Роман Воробец on 16.03.2021.
//

import UIKit

class CellSortSelection: UITableViewCell {
    
    var m_curSelection = Sorting.server
    weak var delegate: VcWarezList?

    @IBOutlet weak var ui_sort_sc: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ui_sort_sc.setEnabled(m_curSelection == Sorting.server, forSegmentAt: 0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    @IBAction func on_uiSortSc_vc(_ sender: UISegmentedControl) {
//        print(sender.selectedSegmentIndex)
        m_curSelection = sender.selectedSegmentIndex == 0 ? .server : .time
        delegate?.setSortingType(sortingType: m_curSelection)
    }
    
}
