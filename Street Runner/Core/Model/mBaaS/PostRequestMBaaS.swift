//
//  PostImageMBaaS.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/30.
//

import Foundation
import NCMB

protocol PostRequestMBaaS{
    func saveRequest(requestImageFile: String, requestText: String, userObjectID: String) -> Result<Void,Error>
    func deleteImagefile(fileName: String)
}

class PostRequestMBaaSImpl: PostRequestMBaaS{
    func saveRequest(requestImageFile: String, requestText: String, userObjectID: String) -> Result<Void,Error>{
        let object = NCMBObject(className: "request")
        object["requestImage"] = requestImageFile
        object["requestText"] = requestText
        object["userObjectID"] = userObjectID
        let result = object.save()
        switch result{
        case .success:
            return Result.success(())
        case .failure(let err):
            print(err)
            return Result.failure(err)
        }
    }
    
    func deleteImagefile(fileName: String){
        let file = NCMBFile(fileName: fileName)
        file.delete()
    }
}
