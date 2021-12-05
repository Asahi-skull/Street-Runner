//
//  ShowPostedTableCell.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/04.
//

import UIKit

class ShowPostedTableCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let PostedCollectionNib = UINib(nibName: "ShowPostedCollectionCell", bundle: nil)
        collectionView.register(PostedCollectionNib, forCellWithReuseIdentifier: "postedCollectionCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
