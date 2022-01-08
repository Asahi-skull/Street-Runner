//
//  UserDetailViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2022/01/08.
//

import Foundation
import UIKit

protocol UserDetailViewModel{
    func getImage(fileName: String, imageView: UIImageView)
    func getEntity() -> detailData
    func getUserInfo(compltion: @escaping (Result<UserData,Error>) -> Void)
}

class UserDetailViewModelImpl: UserDetailViewModel{
    init(entity: detailData){
        self.entity = entity
    }
    
    private let entity: detailData
    private let showPosted: ShowPostedMBaaS = ShowPostedMBaaSImpl()
    private let userInfo: CommentMBaaS = CommentMBaaSImpl()
    
    func getImage(fileName: String, imageView: UIImageView) {
        showPosted.getIconImage(fileName: fileName, imageView: imageView)
    }
    
    func getEntity() -> detailData {
        entity
    }
    
    func getUserInfo(compltion: @escaping (Result<UserData,Error>) -> Void){
        guard let userObjectId = entity.userObjectID else {return}
        userInfo.getUserData(userObjectId: userObjectId) {
            switch $0{
            case .success(let data):
                compltion(Result.success(data))
            case .failure(let err):
                compltion(Result.failure(err))
            }
        }
    }
}
