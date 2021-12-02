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
    
    func saveImageFile(img: UIImage) -> Result<String,Error>{
        let fileName = postRequest.getUUID()
        let result = postRequest.saveImageFile(img: img, fileName: fileName)
        switch result{
        case .success(let data):
            return Result.success(data)
        case .failure(let err):
            return Result.failure(err)
        }
    }
    
    func saveRequest(requestImageFile: String, requestText: String) -> Result<Void, Error>{
        let userObjectID = postRequest.getUserObjectID()
        let userName = postRequest.getuserName()
        let result = postRequest.saveRequest(requestImageFile: requestImageFile, requestText: requestText, userObjectID: userObjectID, userName: userName)
        switch result{
        case .success:
            return Result.success(())
        case .failure(let err):
            return Result.failure(err)
        }
    }
    
    func deleteImageFile(fileName: String){
        postRequest.deleteImageFile(fileName: fileName)
    }
}
