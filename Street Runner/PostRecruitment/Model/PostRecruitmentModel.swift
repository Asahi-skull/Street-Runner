//
//  PostRecruitmentModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/12.
//

import Foundation
import UIKit

protocol PostRecruitmentModel{
    func getUUID() -> String
    func getuserName() -> String
    func getUserObjectID() -> String
    func saveImageFile(img: UIImage, fileName: String) -> Result<String, Error>
    func saveRecruitment(recruitmentImageFile: String, recruitmentText: String, userObjectID: String, userName: String) -> Result<Void,Error>
    func deleteImageFile(fileName: String)
}

class PostRecruitmentModelImpl: PostRecruitmentModel{
    let profile: ProfilemBaaS = ProfilemBaaSImpl()
    let saveImage: EditProfilemBaaS = EditProfilemBaaSImpl()
    let saveRecruitment: PostRecruitmentMBaaS = PostRecruitmentMBaaSImpl()
    
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
    
    func saveRecruitment(recruitmentImageFile: String, recruitmentText: String, userObjectID: String, userName: String) -> Result<Void,Error>{
        saveRecruitment.saveRecruitment(recruitmentImageFile: recruitmentImageFile, recruitmentText: recruitmentText, userObjectID: userObjectID, userName: userName)
    }
    
    func deleteImageFile(fileName: String){
        saveRecruitment.deleteImagefile(fileName: fileName)
    }
}
