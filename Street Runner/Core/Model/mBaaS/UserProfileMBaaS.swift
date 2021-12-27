//
//  UserProfileMBaaS.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/27.
//

import Foundation
import NCMB

protocol UserProfileMBaaS{
    func follow(followedBy: String,followOn: String)
    func unFollow(followedBy: String,followOn: String)
    func checkFollow(followedBy: String,followOn: String) -> Result<Int,Error> 
}

class UserProfileMBaaSImpl: UserProfileMBaaS{
    func follow(followedBy: String,followOn: String) {
        let object = NCMBObject(className: "follow")
        object["followedBy"] = followedBy
        object["followOn"] = followOn
        object.saveInBackground {
            switch $0{
            case .success:
                break
            case .failure:
                return
            }
        }
    }
    
    func unFollow(followedBy: String,followOn: String) {
        var quary = NCMBQuery.getQuery(className: "follow")
        quary.where(field: "followedBy", equalTo: followedBy)
        quary.where(field: "followOn", equalTo: followOn)
        let result = quary.find()
        switch result{
        case .success(let datas):
            for data in datas{
                let res = data.delete()
                switch res {
                case .success:
                    break
                case .failure:
                    return
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
}
