//
//  EditProfileModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/25.
//

import Foundation
import UIKit

protocol EditProfileModel{
    func saveImageFile(img: UIImage,fileName: String) -> Result<String,Error>
    func saveImageUser(fileName: String)
    func getId() -> String
    func getIconImage(fileName: String) -> Result<UIImage,Error>
    func getUserName() -> String
    func saveUserName(userName: String)
}

class EditProfileModelImpl: EditProfileModel{
    let editProfile: EditProfilemBaaSImpl = EditProfilemBaaSImpl()
    let profile: ProfilemBaaS = ProfilemBaaSImpl()
    
    func saveImageFile(img: UIImage,fileName: String) -> Result<String,Error> {
        editProfile.saveImageFile(img: img, fileName: fileName)
    }
    
    func saveImageUser(fileName: String) {
        editProfile.saveImageuser(fileName: fileName)
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
    
    func getUserName() -> String {
        profile.getUser()
    }
    
    func saveUserName(userName: String) {
        editProfile.saveUserName(userName: userName)
    }
}
