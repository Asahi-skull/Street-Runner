//
//  FollowListViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2022/01/04.
//

import Foundation

protocol FollowListViewModel {
    func getFollowerData(completion: @escaping (Result<Void,Error>) -> Void)
    func getFollowingData(completion: @escaping (Result<Void,Error>) -> Void)
    func dataCount() -> Int
    func getData(indexPath: IndexPath) -> String
    func getUserData(userObjectId: String,completion: @escaping (Result<UserData,Error>) -> Void)
    func setIconImage(fileName: String,completion: @escaping (Result<Data,Error>) -> Void)
}

class FollowListViewModelImpl: FollowListViewModel {
    private let followListMbaas: FollowListMbaas = FollowListMbaasImpl()
    private let profileMbaas: ProfilemBaaS = ProfilemBaaSImpl()
    private let commentMbaas: CommentMBaaS = CommentMBaaSImpl()
    private let iconMbaas: ShowPostedMBaaS = ShowPostedMBaaSImpl()
    private var datas: [String] = []
    
    func getFollowerData(completion: @escaping (Result<Void,Error>) -> Void) {
        let currentUserObjectId = profileMbaas.getID()
        followListMbaas.getFollower(userObjectId: currentUserObjectId) { [weak self] in
            guard let self = self else {return}
            switch $0 {
            case .success(let datas):
                self.datas = datas
                completion(Result.success(()))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func getFollowingData(completion: @escaping (Result<Void,Error>) -> Void) {
        let currentUserObjectId = profileMbaas.getID()
        followListMbaas.getFollowing(userObjectId: currentUserObjectId) { [weak self] in
            guard let self = self else {return}
            switch $0 {
            case .success(let datas):
                self.datas = datas
                completion(Result.success(()))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func dataCount() -> Int {
        datas.count
    }
    
    func getData(indexPath: IndexPath) -> String {
        datas[indexPath.row]
    }
    
    func getUserData(userObjectId: String,completion: @escaping (Result<UserData,Error>) -> Void) {
        commentMbaas.getUserData(userObjectId: userObjectId) {
            switch $0{
            case .success(let data):
                completion(Result.success(data))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func setIconImage(fileName: String,completion: @escaping (Result<Data,Error>) -> Void) {
        iconMbaas.getIconImage(fileName: fileName) {
            switch $0 {
            case .success(let imageData):
                completion(Result.success(imageData))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
}
