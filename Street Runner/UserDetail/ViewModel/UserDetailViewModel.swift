//
//  UserDetailViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2022/01/08.
//

import Foundation

protocol UserDetailViewModel{
    func getImage(fileName: String,compltion: @escaping (Result<Data,Error>) -> Void)
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
    
    func getImage(fileName: String,compltion: @escaping (Result<Data,Error>) -> Void) {
        showPosted.getIconImage(fileName: fileName) {
            switch $0 {
            case .success(let imageData):
                compltion(Result.success(imageData))
            case .failure(let err):
                compltion(Result.failure(err))
            }
        }
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
