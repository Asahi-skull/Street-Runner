//
//  EditProfilemBaaS.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/25.
//

import Foundation
import NCMB
import UIKit

enum EditProfilemBaaSError: Error,LocalizedError{
    case loseUser
    var errorDescription:String?{
        switch self {
        case .loseUser:
            return "currentUser取得失敗"
        }
    }
}

protocol EditProfilemBaaS{
    func saveImageFile(img: UIImage, fileName: String) -> Result<String,Error>
    func saveImageuser(fileName: String) -> Result<Void,Error>
    func saveUserName(userName: String) -> Result<Void,Error>
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
    
    func saveImageuser(fileName: String) -> Result<Void,Error>{
        guard let user = NCMBUser.currentUser else {return Result.failure(EditProfilemBaaSError.loseUser)}
        user["iconImage"] = fileName
        let result = user.save()
        switch result{
        case .success:
            return Result.success(())
        case .failure(let err):
            return Result.failure(err)
        }
    }
    
    func saveUserName(userName: String) -> Result<Void,Error>{
        guard let user = NCMBUser.currentUser else {return Result.failure(EditProfilemBaaSError.loseUser)}
        user.userName = userName
        let result = user.save()
        switch result{
        case .success:
            return Result.success(())
        case .failure(let err):
            return Result.failure(err)
        }
    }
}
