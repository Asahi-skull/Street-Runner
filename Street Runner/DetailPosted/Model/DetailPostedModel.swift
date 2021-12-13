//
//  DetailPostedModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/13.
//

import Foundation
import UIKit

protocol DetailPostedModel{
    func getImage(fileName: String, imageView: UIImageView)
}

class DetailPostedModelImpl: DetailPostedModel{
    let showPosted: ShowPostedMBaaS = ShowPostedMBaaSImpl()
    
    func getImage(fileName: String, imageView: UIImageView) {
        showPosted.getIconImage(fileName: fileName, imageView: imageView)
    }
}
