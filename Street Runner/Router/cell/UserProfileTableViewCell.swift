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
    @IBOutlet weak var followButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImage.layer.cornerRadius = 40
        followButton.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func notFollowUp(){
        followButton.backgroundColor = UIColor(named: "blueBack")
        followButton.setTitle("フォローする", for: .normal)
        followButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func alreadyFollowUp(){
        followButton.backgroundColor = UIColor(named: "whiteBack")
        followButton.layer.borderColor = UIColor(named: "blackBorder")?.cgColor
        followButton.layer.borderWidth = 1.0
        followButton.setTitle("フォロー中", for: .normal)
        followButton.setTitleColor(UIColor(named: "blackText"), for: .normal)
    }
}
