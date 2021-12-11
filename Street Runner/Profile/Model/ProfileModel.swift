//
//  ProfileModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/25.
//

import Foundation
import UIKit

protocol ProfileModel{
    func setUser() -> String
    func getId() -> String
    func getIconImage(fileName: String) -> Result<UIImage,Error>
    func getRequest(className: String,objectID: String) -> Result<[ProfilePostedEntity],Error>
    func getImage(fileName: String,imageView: UIImageView)
}

class ProfileModelImpl: ProfileModel{
    let profile: ProfilemBaaS = ProfilemBaaSImpl()
    let showPosted: ShowPostedMBaaS = ShowPostedMBaaSImpl()
    
    func setUser() -> String{
        profile.getUser()
    }
    
    func getId() -> String {
        profile.getID()
    }
    
    func getIconImage(fileName: String) -> Result<UIImage,Error> {
        let result = profile.getIconImage(fileName: fileName)
        switch result{
        case .success(let image):
            return Result.success(image)
        case .failure(let err):
            return Result.failure(err)
        }
    }
    
    func getRequest(className: String,objectID: String) -> Result<[ProfilePostedEntity],Error>{
        profile.getRequest(className: className, objectID: objectID)
    }
    
    func getImage(fileName: String,imageView: UIImageView){
        showPosted.getIconImage(fileName: fileName, imageView: imageView)
    }
}
