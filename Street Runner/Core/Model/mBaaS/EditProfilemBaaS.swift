//
//  EditProfilemBaaS.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/25.
//

import Foundation
import NCMB
import UIKit

protocol EditProfilemBaaS{
    func saveImageFile(img: UIImage, fileName: String) -> Result<String,Error>
    func saveImageuser(fileName: String)
    func saveUserName(userName: String) -> Bool
}

class EditProfilemBaaSImpl: EditProfilemBaaS{
    func saveImageFile(img: UIImage, fileName: String) -> Result<String,Error> {
        let data = img.pngData()
        let file : NCMBFile = NCMBFile(fileName: fileName)
        let result = file.save(data: data!)
        switch result{
        case .success:
            return Result.success(fileName)
        case .failure(let err):
            return Result.failure(err)
        }
    }
    
    func saveImageuser(fileName: String){
        guard let user = NCMBUser.currentUser else {return}
        user["iconImage"] = fileName
        user.save()
    }
    
    func saveUserName(userName: String) -> Bool{
        guard let user = NCMBUser.currentUser else {return false}
        user.userName = userName
        let result = user.save()
        switch result{
        case .success:
            return true
        case .failure:
            return false
        }
    }
}
