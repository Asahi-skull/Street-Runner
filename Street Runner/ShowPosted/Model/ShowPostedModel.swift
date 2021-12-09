//
//  ShowPostedModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/05.
//

import Foundation
import UIKit

protocol ShowPostedModel{
    func getRequest(className: String) -> Result<[RequestEntity],Error>
    func getIconImage(fileName: String,imageView: UIImageView)
}

class ShowPostedModelImpl: ShowPostedModel{
    let showPosted: ShowPostedMBaaS = ShowPostedMBaaSImpl()
    
    func getRequest(className: String) -> Result<[RequestEntity],Error>{
        showPosted.getRequest(className: className)
    }
    
    func getIconImage(fileName: String,imageView: UIImageView){
        showPosted.getIconImage(fileName: fileName, imageView: imageView)
    }
}
