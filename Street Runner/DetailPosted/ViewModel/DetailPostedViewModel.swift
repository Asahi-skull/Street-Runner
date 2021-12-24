//
//  DetailPostedViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/13.
//

import Foundation
import UIKit

protocol DetailPostedViewModel{
    func getImage(fileName: String, imageView: UIImageView)
    func getEntity() -> detailData
    func getUserInfo(compltion: @escaping (Result<UserData,Error>) -> Void)
}

class DetailPostedViewModelImpl: DetailPostedViewModel{
    init(entity: detailData){
        self.entity = entity
    }
    
    let entity: detailData
    let showPosted: ShowPostedMBaaS = ShowPostedMBaaSImpl()
    let userInfo: CommentMBaaS = CommentMBaaSImpl()
    
    func getImage(fileName: String, imageView: UIImageView) {
        showPosted.getIconImage(fileName: fileName, imageView: imageView)
    }
    
    func getEntity() -> detailData {
        entity
    }
    
    func getUserInfo(compltion: @escaping (Result<UserData,Error>) -> Void){
        guard let userObjectId = entity.userObjectID else {return}
        userInfo.getUserData(userObjectId: userObjectId) { result in
            switch result{
            case .success(let data):
                compltion(Result.success(data))
            case .failure(let err):
                compltion(Result.failure(err))
            }
        }
    }
}
