//
//  PostRequestViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/01.
//

import Foundation
import UIKit

protocol PostRequestViewModel{
    func saveImageFile(img: UIImage) -> Result<String,Error>
    func saveRequest(requestImageFile: String, requestText: String) -> Result<Void,Error>
    func deleteImageFile(fileName: String)
}

class PostRequestViewModelImpl: PostRequestViewModel{
    let postRequest: PostRequestModel = PostRequestModelImpl()
    let profile: ProfilemBaaS = ProfilemBaaSImpl()
    let saveImage: EditProfilemBaaS = EditProfilemBaaSImpl()
    let saveRequest: PostRequestMBaaS = PostRequestMBaaSImpl()
    
    func saveImageFile(img: UIImage) -> Result<String,Error>{
        let fileName = postRequest.getUUID()
        let result = saveImage.saveImageFile(img: img, fileName: fileName)
        switch result{
        case .success(let data):
            return Result.success(data)
        case .failure(let err):
            return Result.failure(err)
        }
    }
    
    func saveRequest(requestImageFile: String, requestText: String) -> Result<Void, Error>{
        let userObjectID = profile.getID()
        let userName = profile.getUser()
        print(userName)
        print(userObjectID)
        let result = saveRequest.saveRequest(requestImageFile: requestImageFile, requestText: requestText, userObjectID: userObjectID, userName: userName)
        switch result{
        case .success:
            return Result.success(())
        case .failure(let err):
            return Result.failure(err)
        }
    }
    
    func deleteImageFile(fileName: String){
        saveRequest.deleteImagefile(fileName: fileName)
    }
}
