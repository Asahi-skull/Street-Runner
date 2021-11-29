//
//  EditProfileViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/25.
//

import Foundation
import UIKit

protocol EditProfileViewModel{
    func saveImage(img: UIImage) -> Result<Void,Error>
    func getIconImage() -> Result<UIImage,Error>
    func getUserName() -> String
    func saveUserName(userName: String) ->  Result<Void,Error>
}

class EditProfileViewModelImpl: EditProfileViewModel{
    let editProfile: EditProfileModel = EditProfileModelImpl()
    
    func saveImage(img: UIImage) -> Result<Void,Error> {
        let fileName = editProfile.getId()
        let result = editProfile.saveImageFile(img: img, fileName: fileName)
        switch result{
        case .success:
            let res = editProfile.saveImageUser(fileName: fileName)
            switch res{
            case .success:
                break
            case .failure(let err):
                return Result.failure(err)
            }
            return Result.success(())
        case .failure(let err):
            return Result.failure(err)
        }
    }
    
    func getIconImage() -> Result<UIImage,Error>{
        let fileName = editProfile.getId()
        let imageResult = editProfile.getIconImage(fileName: fileName)
        return imageResult
    }
    
    func getUserName() -> String {
        editProfile.getUserName()
    }
    
    func saveUserName(userName: String) ->  Result<Void,Error>{
        editProfile.saveUserName(userName: userName)
    }
}
