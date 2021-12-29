//
//  UserProfileMBaaS.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/27.
//

import Foundation
import NCMB

protocol UserProfileMBaaS{
    func follow(followedBy: String,followOn: String,comletion: @escaping (Result<Void,Error>) -> Void)
    func unFollow(followedBy: String,followOn: String,completion: @escaping (Result<Void,Error>) -> Void)
    func checkFollow(followedBy: String,followOn: String) -> Result<Int,Error>
    func countFollow(field: String,userObjectId: String,completion: @escaping (Result<Int,Error>) -> Void)}

class UserProfileMBaaSImpl: UserProfileMBaaS{
    func follow(followedBy: String,followOn: String,comletion: @escaping (Result<Void,Error>) -> Void) {
        let object = NCMBObject(className: "follow")
        object["followedBy"] = followedBy
        object["followOn"] = followOn
        object.saveInBackground {
            switch $0{
            case .success:
                comletion(Result.success(()))
            case .failure(let err):
                comletion(Result.failure(err))
            }
        }
    }
    
    func unFollow(followedBy: String,followOn: String,completion: @escaping (Result<Void,Error>) -> Void) {
        var quary = NCMBQuery.getQuery(className: "follow")
        quary.where(field: "followedBy", equalTo: followedBy)
        quary.where(field: "followOn", equalTo: followOn)
        let result = quary.find()
        switch result{
        case .success(let datas):
            for data in datas{
                data.deleteInBackground {
                    switch $0 {
                    case .success:
                        completion(Result.success(()))
                    case .failure(let err):
                        completion(Result.failure(err))
                    }
                }
            }
        case .failure:
            return
        }
    }
    
    func checkFollow(followedBy: String,followOn: String) -> Result<Int,Error> {
        var quary = NCMBQuery.getQuery(className: "follow")
        quary.where(field: "followedBy", equalTo: followedBy)
        quary.where(field: "followOn", equalTo: followOn)
        let result = quary.count()
        switch result{
        case .success(let int):
            return Result.success(int)
        case .failure(let err):
            return Result.failure(err)
        }
    }
    
    func countFollow(field: String,userObjectId: String,completion: @escaping (Result<Int,Error>) -> Void) {
        var quary = NCMBQuery.getQuery(className: "follow")
        quary.where(field: field, equalTo: userObjectId)
        quary.countInBackground {
            switch $0{
            case .success(let int):
                completion(Result.success(int))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
}
