//
//  ProfileDetailViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2022/01/10.
//

import Foundation
import UIKit

protocol ProfileDetailViewModel{
    func getImage(fileName: String, imageView: UIImageView)
    func getEntity() -> ProfileDetailData
    func getUserInfo(compltion: @escaping (Result<UserData,Error>) -> Void)
    func getCurrentUserId() -> String
}

class ProfileDetailViewModelImpl: ProfileDetailViewModel {
    init(entity: ProfileDetailData){
        self.entity = entity
    }
    
    private let entity: ProfileDetailData
    private let showPosted: ShowPostedMBaaS = ShowPostedMBaaSImpl()
    private let userInfo: CommentMBaaS = CommentMBaaSImpl()
    private let profile: ProfilemBaaS = ProfilemBaaSImpl()
    
    func getImage(fileName: String, imageView: UIImageView) {
        showPosted.getIconImage(fileName: fileName, imageView: imageView)
    }
    
    func getEntity() -> ProfileDetailData {
        entity
    }
    
    func getUserInfo(compltion: @escaping (Result<UserData,Error>) -> Void){
        let userObjectId = profile.getID()
        userInfo.getUserData(userObjectId: userObjectId) {
            switch $0{
            case .success(let data):
                compltion(Result.success(data))
            case .failure(let err):
                compltion(Result.failure(err))
            }
        }
    }
    
    func getCurrentUserId() -> String {
        profile.getID()
    }
}
