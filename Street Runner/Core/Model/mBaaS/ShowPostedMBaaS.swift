//
//  ShowPostedMBaaS.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/05.
//

import Foundation
import NCMB
import UIKit

enum ShowPostedMBaaSError: Error,LocalizedError{
    case loseObjectID
    case loseRequestImage
    case loseRequestText
    case loseUserName
    case loseUserObjectID
    var errorDescription: String?{
        switch self {
        case .loseObjectID:
            return "ObjectIDの取得失敗"
        case .loseRequestImage:
            return "requestImageの取得失敗"
        case .loseRequestText:
            return "requestTextの取得失敗"
        case .loseUserName:
            return "userNameの取得失敗"
        case .loseUserObjectID:
            return "userObjectIDの取得失敗"
        }
    }
}

protocol ShowPostedMBaaS{
    func getRequest(className: String) -> Result<[RequestEntity],Error>
    func getIconImage(fileName: String,imageView: UIImageView)
}

class ShowPostedMBaaSImpl: ShowPostedMBaaS{
    func getRequest(className: String) -> Result<[RequestEntity],Error> {
        let query = NCMBQuery.getQuery(className: className)
        let result = query.find()
        switch result{
        case .success(let datas):
            var requestEntitys: [RequestEntity] = []
            for data in datas{
                let objectID: String? = data["objectId"]
                let requestImage: String? = data["requestImage"]
                let requestText: String? = data["requestText"]
                let userName: String? = data["userName"]
                let userObjectID: String? = data["userObjectID"]
//                guard let objectID: String = data["objectID"] else {return Result.failure(ShowPostedMBaaSError.loseObjectID)}
//                guard let requestImage: String = data["requestImage"] else {return Result.failure(ShowPostedMBaaSError.loseRequestImage)}
//                guard let requestText: String = data["requestText"] else {return Result.failure(ShowPostedMBaaSError.loseRequestText)}
//                guard let userName: String = data["userName"] else {return Result.failure(ShowPostedMBaaSError.loseUserName)}
//                guard let userObjectID: String = data["userObjectID"] else {return Result.failure(ShowPostedMBaaSError.loseUserObjectID)}
                let requestEntity = RequestEntity(objectID: objectID, requestImage: requestImage, requestText: requestText, userName: userName, userObjectID: userObjectID)
                requestEntitys.append(requestEntity)
            }
            return Result.success(requestEntitys)
        case .failure(let err):
            return Result.failure(err)
        }
    }
    
    func getIconImage(fileName: String,imageView: UIImageView) {
        let file: NCMBFile = NCMBFile(fileName: fileName)
        file.fetchInBackground(callback: {result in
            switch result{
            case .success(let data):
                if let imageData = data{
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async{
                        imageView.image = image
                    }
                }else{
                    return
                }
            case .failure:
                return
            }
        })
    }
}
