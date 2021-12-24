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
    let profile: ProfilemBaaS = ProfilemBaaSImpl()
    let saveImage: EditProfilemBaaS = EditProfilemBaaSImpl()
    let saveRecruitment: PostRecruitmentMBaaS = PostRecruitmentMBaaSImpl()
    
    func saveImageFile(img: UIImage) -> Result<String, Error> {
        let fileName = postRecruitment.getUUID()
        let result = saveImage.saveImageFile(img: img, fileName: fileName)
        switch result{
        case .success(let data):
            return Result.success(data)
        case .failure(let err):
            return Result.failure(err)
        }
    }
    
    func saveRecruitment(requestImageFile: String, requestText: String) -> Result<Void, Error> {
        let userObjectID = profile.getID()
        let result = saveRecruitment.saveRecruitment(recruitmentImageFile: requestImageFile, recruitmentText: requestText, userObjectID: userObjectID)
        switch result{
        case .success:
            return Result.success(())
        case .failure(let err):
            return Result.failure(err)
        }
    }
    
    func deleteImageFile(fileName: String) {
        saveRecruitment.deleteImagefile(fileName: fileName)
    }
}
