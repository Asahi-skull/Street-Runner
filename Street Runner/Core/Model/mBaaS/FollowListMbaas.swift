//
//  FollowListMbaas.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2022/01/04.
//

import Foundation
import UIKit
import NCMB

protocol FollowListMbaas {
    func getFollower(userObjectId: String,completion: @escaping (Result<[String],Error>) -> Void)
    func getFollowing(userObjectId: String,completion: @escaping (Result<[String],Error>) -> Void)
}

class FollowListMbaasImpl: FollowListMbaas {
    func getFollower(userObjectId: String,completion: @escaping (Result<[String],Error>) -> Void) {
        var quary = NCMBQuery.getQuery(className: "follow")
        quary.where(field: "followedBy", equalTo: userObjectId)
        quary.findInBackground {
            switch $0 {
            case .success(let datas):
                var IDs: [String] = []
                for data in datas {
                    let userId: String? = data["followOn"]
                    guard let userId = userId else {return}
                    let Id = userId
                    IDs.append(Id)
                }
                completion(Result.success(IDs))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func getFollowing(userObjectId: String,completion: @escaping (Result<[String],Error>) -> Void) {
        var quary = NCMBQuery.getQuery(className: "follow")
        quary.where(field: "followOn", equalTo: userObjectId)
        quary.findInBackground {
            switch $0 {
            case .success(let datas):
                var userIDs: [String] = []
                for data in datas {
                    let userId: String? = data["followedBy"]
                    guard let userId = userId else {return}
                    userIDs.append(userId)
                }
                completion(Result.success(userIDs))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
}
