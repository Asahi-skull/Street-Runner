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
    func getEntity() -> RequestEntity
}

class DetailPostedViewModelImpl: DetailPostedViewModel{
    init(entity: RequestEntity){
        self.entity = entity
    }
    
    let entity: RequestEntity
    let model: DetailPostedModel = DetailPostedModelImpl()
    
    func getImage(fileName: String, imageView: UIImageView) {
        model.getImage(fileName: fileName, imageView: imageView)
    }
    
    func getEntity() -> RequestEntity {
        entity
    }
}
