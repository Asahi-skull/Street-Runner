//
//  FollowDetailViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2022/01/11.
//

import Foundation

protocol FollowDetailViewModel{
    func getImage(fileName: String,completion: @escaping (Result<Data,Error>) -> Void)
    func getEntity() -> detailData
    func getUserInfo(completion: @escaping (Result<UserData,Error>) -> Void)
}

class FollowDetailViewModelImpl: FollowDetailViewModel{
    init(entity: detailData){
        self.entity = entity
    }
    
    private let entity: detailData
    private let showPosted: ShowPostedMBaaS = ShowPostedMBaaSImpl()
    private let userInfo: CommentMBaaS = CommentMBaaSImpl()
    
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
    
    func getEntity() -> detailData {
        entity
    }
    
    func getUserInfo(completion: @escaping (Result<UserData,Error>) -> Void){
        guard let userObjectId = entity.userObjectID else {return}
        userInfo.getUserData(userObjectId: userObjectId) {
            switch $0{
            case .success(let data):
                completion(Result.success(data))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
}
