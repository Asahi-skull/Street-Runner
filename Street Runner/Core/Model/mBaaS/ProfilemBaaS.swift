//
//  ProfileModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/22.
//

import Foundation
import NCMB
import UIKit

protocol ProfilemBaaS{
    func getUser() -> String
    func getIconImage(fileName: String) -> Result<UIImage,Error>
    func getID() -> String
    func getRequest(className: String,objectID: String) -> Result<[ProfilePostedEntity],Error>
}

class ProfilemBaaSImpl: ProfilemBaaS{
    func getUser() -> String {
        guard let user = NCMBUser.currentUser else {return ""}
        guard let userName = user.userName else {return ""}
        return userName
    }
    
    func getIconImage(fileName: String) -> Result<UIImage,Error> {
        let file: NCMBFile = NCMBFile(fileName: fileName)
        let result = file.fetch()
        switch result{
        case .success(let data):
            if let imageData = data{
                if let image = UIImage(data: imageData){
                    return Result.success(image)
                }else{
                    return Result.failure(Error.self as! Error)
                }
            }else{
                return Result.failure(Error.self as! Error)
            }
        case .failure(let err):
            return Result.failure(err)
        }        
    }
    
    func getID() -> String {
        guard let user = NCMBUser.currentUser else {return ""}
        guard let usesrId = user.objectId else {return ""}
        return usesrId
    }
    
    func getRequest(className: String,objectID: String) -> Result<[ProfilePostedEntity],Error> {
        var query = NCMBQuery.getQuery(className: className)
        query.where(field: "userObjectID", equalTo: objectID)
        let result = query.find()
        switch result{
        case .success(let datas):
            var profilePostedEntitys: [ProfilePostedEntity] = []
            for data in datas{
                let objectID: String? = data["objectID"]
                let requestImage: String? = data["requestImage"]
                let requestText: String? = data["requestText"]
                let profilePostedEntity = ProfilePostedEntity(objectID: objectID, requestImage: requestImage, requestText: requestText)
                profilePostedEntitys.append(profilePostedEntity)
            }
            return Result.success(profilePostedEntitys)
        case .failure(let err):
            return Result.failure(err)
        }
    }
}
