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
}

class ProfileModelImpl: ProfileModel{
    let profile: ProfilemBaaS = ProfilemBaaSImpl()
    
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
}