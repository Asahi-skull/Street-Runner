//
//  PostRequestModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/01.
//

import Foundation
import UIKit

protocol PostRequestModel{
    func getUUID() -> String
    func getuserName() -> String
    func getUserObjectID() -> String
    func saveImageFile(img: UIImage, fileName: String) -> Result<String, Error>
    func saveRequest(requestImageFile: String, requestText: String, userObjectID: String, userName: String) -> Result<Void, Error>
    func deleteImageFile(fileName: String)
}

class PostRequestModelImpl: PostRequestModel{
    let profile: ProfilemBaaS = ProfilemBaaSImpl()
    let saveImage: EditProfilemBaaS = EditProfilemBaaSImpl()
    let saveRequest: PostRequestMBaaS = PostRequestMBaaSImpl()
    
    func getUUID() -> String{
        let uuuid = NSUUID().uuidString
        return uuuid
    }
    
    func getuserName() -> String{
        profile.getUser()
    }
    
    func getUserObjectID() -> String{
        profile.getID()
    }
    
    func saveImageFile(img: UIImage, fileName: String) -> Result<String, Error>{
        saveImage.saveImageFile(img: img, fileName: fileName)
    }
    
    func saveRequest(requestImageFile: String, requestText: String, userObjectID: String, userName: String) -> Result<Void, Error>{
        saveRequest.saveRequest(requestImageFile: requestImageFile, requestText: requestText, userObjectID: userObjectID, userName: userName)
    }
    
    func deleteImageFile(fileName: String){
        saveRequest.deleteImagefile(fileName: fileName)
    }
}
