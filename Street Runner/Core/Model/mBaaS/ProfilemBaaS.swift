//
//  ProfileModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/22.
//

import Foundation
import NCMB

protocol ProfilemBaaS{
    func getUser() -> String
    func getID() -> String
    func getRequest(className: String,objectID: String,completion: @escaping (Result<[ProfilePostedEntity],Error>) -> Void)
}

class ProfilemBaaSImpl: ProfilemBaaS{
    func getUser() -> String {
        guard let user = NCMBUser.currentUser else {return ""}
        guard let userName = user.userName else {return ""}
        return userName
    }
    
    func getID() -> String {
        guard let user = NCMBUser.currentUser else {return ""}
        guard let usesrId = user.objectId else {return ""}
        return usesrId
    }
    
    func getRequest(className: String,objectID: String,completion: @escaping (Result<[ProfilePostedEntity],Error>) -> Void){
        var query = NCMBQuery.getQuery(className: className)
        query.where(field: "userObjectID", equalTo: objectID)
        query.findInBackground { result in
            switch result{
            case .success(let datas):
                var profilePostedEntitys: [ProfilePostedEntity] = []
                for data in datas.reversed(){
                    let objectID: String? = data.objectId
                    let requestImage: String? = data["requestImage"]
                    let requestText: String? = data["requestText"]
                    let profilePostedEntity = ProfilePostedEntity(objectID: objectID, requestImage: requestImage, requestText: requestText)
                    profilePostedEntitys.append(profilePostedEntity)
                }
                completion(Result.success(profilePostedEntitys))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
}
