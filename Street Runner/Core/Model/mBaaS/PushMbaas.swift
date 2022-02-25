//
//  PushMbaas.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2022/02/01.
//

import Foundation
import NCMB

protocol PushMbaas {
    func push(title: String,message: String,category: String,userId: String,completion: @escaping (Result<Void,Error>) -> Void)
    func setUserIdToInstallation(completion: @escaping (Result<Void,Error>) -> Void)
}

class PushMbaasImpl: PushMbaas {
    func push(title: String,message: String,category: String,userId: String,completion: @escaping (Result<Void,Error>) -> Void) {
        let push = NCMBPush()
        push.sound = "defalt"
        push.badgeIncrementFlag = true
        push.contentAvailable = false
        push.title = title
        push.message = message
        push.category = category
        push.badgeIncrementFlag = false
        push.setImmediateDelivery()
        var query = NCMBInstallation.query
        query.where(field: "userId", equalTo: userId)
        push.searchCondition = query
        push.sendInBackground {
            switch $0 {
            case .success:
                completion(Result.success(()))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func setUserIdToInstallation(completion: @escaping (Result<Void,Error>) -> Void) {
        let user = NCMBUser.currentUser?.objectId
        let Installation = NCMBInstallation.currentInstallation
        Installation["userId"] = user
        Installation.saveInBackground {
            switch $0 {
            case .success:
                completion(Result.success(()))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
}
