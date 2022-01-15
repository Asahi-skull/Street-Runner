//
//  ShowPostedMBaaS.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/05.
//

import Foundation
import NCMB

protocol ShowPostedMBaaS{
    func getRequest(className: String,completion: @escaping (Result<[RequestEntity],Error>) -> Void)
    func getIconImage(fileName: String,completion: @escaping (Result<Data,Error>) -> Void)
}

class ShowPostedMBaaSImpl: ShowPostedMBaaS{
    func getRequest(className: String,completion: @escaping (Result<[RequestEntity],Error>) -> Void) {
        let query = NCMBQuery.getQuery(className: className)
        query.findInBackground { result in
            switch result{
            case .success(let datas):
                var requestEntitys: [RequestEntity] = []
                for data in datas.reversed() {
                    let objectID: String? = data["objectId"]
                    let requestImage: String? = data["requestImage"]
                    let requestText: String? = data["requestText"]
                    let userObjectID: String? = data["userObjectID"]
                    let requestEntity = RequestEntity(objectID: objectID, requestImage: requestImage, requestText: requestText, userObjectID: userObjectID)
                    requestEntitys.append(requestEntity)
                }
                 completion(Result.success(requestEntitys))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func getIconImage(fileName: String,completion: @escaping (Result<Data,Error>) -> Void) {
        let file: NCMBFile = NCMBFile(fileName: fileName)
        file.fetchInBackground(callback: {result in
            switch result{
            case .success(let data):
                guard let data = data else {return}
                completion(Result.success(data))
            case .failure(let err):
                completion(Result.failure(err))
            }
        })
    }
}
