//
//  CommentMBaaS.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/20.
//

import Foundation
import NCMB

protocol CommentMBaaS{
    func saveComment(commentText: String,postedObjectId: String,userObjectId: String,completion: @escaping (Result<Void,Error>) -> Void)
    func getcomment(postedObjectId: String,completion: @escaping (Result<[CommentEntity],Error>) -> Void)
    func getUserData(userObjectId: String,completion: @escaping (Result<UserData,Error>) -> Void)
}

class CommentMBaaSImpl: CommentMBaaS{
    func saveComment(commentText: String,postedObjectId: String,userObjectId: String,completion: @escaping (Result<Void,Error>) -> Void) {
        let object = NCMBObject(className: "comment")
        object["commentText"] = commentText
        object["postedObjectId"] = postedObjectId
        object["userObjectId"] = userObjectId
        object.saveInBackground {
            switch $0{
            case .success:
                completion(Result.success(()))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func getcomment(postedObjectId: String,completion: @escaping (Result<[CommentEntity],Error>) -> Void){
        var query = NCMBQuery.getQuery(className: "comment")
        query.where(field: "postedObjectId", equalTo: postedObjectId)
        query.findInBackground {
            switch $0{
            case .success(let datas):
                var commentEntitys: [CommentEntity] = []
                for data in datas{
                    let commentText: String? = data["commentText"]
                    let postedObjectId: String? = data["postedObjectId"]
                    let userObjectId: String? = data["userObjectId"]
                    let commentEntity = CommentEntity(commentText: commentText, postedObjectId: postedObjectId, userObjectId: userObjectId)
                    commentEntitys.append(commentEntity)
                }
                completion(Result.success(commentEntitys))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func getUserData(userObjectId: String,completion: @escaping (Result<UserData,Error>) -> Void){
        let user: NCMBUser = NCMBUser()
        user.objectId = userObjectId
        user.fetchInBackground {
            switch $0 {
            case .success:
                let userName = user.userName
                let iconImageFile: String? = user["iconImage"]
                let commentEntity = UserData(userName: userName, iconImageFile: iconImageFile)
                completion(Result.success(commentEntity))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
}
