//
//  UserProfileTableViewCell.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/25.
//

import UIKit

class UserProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImage.layer.cornerRadius = 40
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
