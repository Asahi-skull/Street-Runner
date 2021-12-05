//
//  ShowPostedMBaaS.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/05.
//

import Foundation
import NCMB

protocol ShowPostedMBaaS{
    func getRequest(className: String) -> Result<[RequestEntity],Error>
}

class ShowPostedMBaaSImpl: ShowPostedMBaaS{
    func getRequest(className: String) -> Result<[RequestEntity],Error> {
        let query = NCMBQuery.getQuery(className: className)
        let result = query.find()
        switch result{
        case .success(let datas):
            var requestEntitys: [RequestEntity] = []
            for data in datas{
                let objectID: String? = data.objectId
                let requestImage: String? = data["requestImage"]
                let requestText: String? = data["requestText"]
                let userName: String? = data["userName"]
                let userObjectID: String? = data["userObjectID"]
                let requestEntity = RequestEntity(objectID: objectID, requestImage: requestImage, requestText: requestText, userName: userName, userObjectID: userObjectID)
                requestEntitys.append(requestEntity)
            }
            return Result.success(requestEntitys)
        case .failure(let err):
            return Result.failure(err)
        }
    }
}
