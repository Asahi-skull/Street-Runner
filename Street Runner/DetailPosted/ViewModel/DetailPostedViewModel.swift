//
//  DetailPostedViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/13.
//

import Foundation
import UIKit

protocol DetailPostedViewModel{
    func getImage(fileName: String, imageView: UIImageView)
    func getEntity() -> detailData
}

class DetailPostedViewModelImpl: DetailPostedViewModel{
    init(entity: detailData){
        self.entity = entity
    }
    
    let entity: detailData
    let showPosted: ShowPostedMBaaS = ShowPostedMBaaSImpl()
    
    func getImage(fileName: String, imageView: UIImageView) {
        showPosted.getIconImage(fileName: fileName, imageView: imageView)
    }
    
    func getEntity() -> detailData {
        entity
    }
}
