//
//  PostRecruitmentViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/12.
//

import Foundation
import UIKit

protocol PostRecruitmentViewModel{
    func saveImageFile(img: UIImage) -> Result<String,Error>
    func saveRecruitment(requestImageFile: String, requestText: String) -> Result<Void,Error>
    func deleteImageFile(fileName: String)
}

class PostRecruitmentViewModelImpl: PostRecruitmentViewModel{
    let postRecruitment: PostRecruitmentModel = PostRecruitmentModelImpl()
    
    func saveImageFile(img: UIImage) -> Result<String, Error> {
        let fileName = postRecruitment.getUUID()
        let result = postRecruitment.saveImageFile(img: img, fileName: fileName)
        switch result{
        case .success(let data):
            return Result.success(data)
        case .failure(let err):
            return Result.failure(err)
        }
    }
    
    func saveRecruitment(requestImageFile: String, requestText: String) -> Result<Void, Error> {
        let userObjectID = postRecruitment.getUserObjectID()
        let userName = postRecruitment.getuserName()
        let result = postRecruitment.saveRecruitment(recruitmentImageFile: requestImageFile, recruitmentText: requestText, userObjectID: userObjectID, userName: userName)
        switch result{
        case .success:
            return Result.success(())
        case .failure(let err):
            return Result.failure(err)
        }
    }
    
    func deleteImageFile(fileName: String) {
        postRecruitment.deleteImageFile(fileName: fileName)
    }
}
