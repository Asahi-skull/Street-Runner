//
//  ProfilePostedTableViewCell.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/10.
//

import UIKit

class ProfilePostedTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let profilePostedCollectionNib = UINib(nibName: "ProfilePostedCollectionViewCell", bundle: nil)
        collectionView.register(profilePostedCollectionNib, forCellWithReuseIdentifier: "profilePostedCollectionCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
