//
//  ProfileDetailViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2022/01/10.
//

import Foundation

protocol ProfileDetailViewModel{
    func getImage(fileName: String,completion: @escaping (Result<Data,Error>) -> Void)
    func getEntity() -> ProfileDetailData
    func getUserInfo(completion: @escaping (Result<UserData,Error>) -> Void)
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
    
    func getImage(fileName: String,completion: @escaping (Result<Data,Error>) -> Void) {
        showPosted.getIconImage(fileName: fileName) {
            switch $0 {
            case .success(let imageData):
                completion(Result.success(imageData))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func getEntity() -> ProfileDetailData {
        entity
    }
    
    func getUserInfo(completion: @escaping (Result<UserData,Error>) -> Void){
        let userObjectId = profile.getID()
        userInfo.getUserData(userObjectId: userObjectId) {
            switch $0{
            case .success(let data):
                completion(Result.success(data))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func getCurrentUserId() -> String {
        profile.getID()
    }
}
