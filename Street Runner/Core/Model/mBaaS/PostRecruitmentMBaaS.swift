//
//  PostRecruitmentMBaaS.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/12.
//

import Foundation
import NCMB

protocol PostRecruitmentMBaaS{
    func saveRecruitment(recruitmentImageFile: String, recruitmentText: String, userObjectID: String) -> Result<Void,Error>
    func deleteImagefile(fileName: String)
}

class PostRecruitmentMBaaSImpl: PostRecruitmentMBaaS{
    func saveRecruitment(recruitmentImageFile: String, recruitmentText: String, userObjectID: String) -> Result<Void,Error>{
        let object = NCMBObject(className: "recruitment")
        object["requestImage"] = recruitmentImageFile
        object["requestText"] = recruitmentText
        object["userObjectID"] = userObjectID
        let result = object.save()
        switch result{
        case .success:
            return Result.success(())
        case .failure(let err):
            return Result.failure(err)
        }
    }
    
    func deleteImagefile(fileName: String){
        let file = NCMBFile(fileName: fileName)
        file.delete()
    }
}
