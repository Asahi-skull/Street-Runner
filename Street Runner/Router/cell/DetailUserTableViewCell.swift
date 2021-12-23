//
//  DetailUserTableViewCell.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/13.
//

import UIKit

class DetailUserTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImage.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(entity: detailData){
        userNameLabel.text = entity.userName
    }
}
