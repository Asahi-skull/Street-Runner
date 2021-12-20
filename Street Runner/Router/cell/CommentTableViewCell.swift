//
//  CommentTableViewCell.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/20.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userCommentText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImage.layer.cornerRadius = 25
        userCommentText.isEditable = false
        userCommentText.isSelectable = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
