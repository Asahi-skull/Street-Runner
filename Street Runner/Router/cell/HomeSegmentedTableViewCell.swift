//
//  HomeSegmentedTableViewCell.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/25.
//

import UIKit

class HomeSegmentedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var segmented: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
