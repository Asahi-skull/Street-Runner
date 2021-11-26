//
//  ProfileViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/22.
//

import Foundation
import UIKit

protocol ProfileViewModel{
    func setUser() -> String
    func getIconImage() -> Result<UIImage,Error>
}

class ProfileViewModelImpl: ProfileViewModel{
    let profileModel: ProfileModel = ProfileModelImpl()
    
    func setUser() -> String {
        profileModel.setUser()
    }
    
    func getIconImage() -> Result<UIImage,Error>{
        let fileName = profileModel.getId()
        let imageResult = profileModel.getIconImage(fileName: fileName)
        return imageResult
    }
}
