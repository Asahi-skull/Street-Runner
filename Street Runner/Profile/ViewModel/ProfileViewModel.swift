//
//  ProfileViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/22.
//

import Foundation

protocol ProfileViewModel{
    func setUser() -> String
    func getIconImage(completion: @escaping (Result<Data,Error>) -> Void)
    func dataCount() -> Int
    func getData(indexPath: IndexPath) -> ProfilePostedEntity
    func getRequest(completion: @escaping (Result<Void,Error>) -> Void)
    func getRecruitmentData(completion: @escaping (Result<Void,Error>) -> Void)
    func getImage(fileName: String,completion: @escaping (Result<Data,Error>) -> Void)
    func countFollower(completion: @escaping (Result<Int,Error>) -> Void)
    func countFollowing(completion: @escaping (Result<Int,Error>) -> Void)
    func countGoodNumber(completion: @escaping (Result<Int,Error>) -> Void)
}

class ProfileViewModelImpl: ProfileViewModel{
    private let profile: ProfilemBaaS = ProfilemBaaSImpl()
    private let showPosted: ShowPostedMBaaS = ShowPostedMBaaSImpl()
    private let followModel: UserProfileMBaaS = UserProfileMBaaSImpl()
    private var datas: [ProfilePostedEntity] = []
    
    func setUser() -> String {
        profile.getUser()
    }
    
    func getIconImage(completion: @escaping (Result<Data,Error>) -> Void) {
        showPosted.getIconImage(fileName: profile.getID()) {
            switch $0 {
            case .success(let imageData):
                completion(Result.success(imageData))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func dataCount() -> Int {
        datas.count
    }
    
    func getData(indexPath: IndexPath) -> ProfilePostedEntity {
        datas[indexPath.row]
    }
    
    func getRequest(completion: @escaping (Result<Void,Error>) -> Void) {
        profile.getRequest(className: "request", objectID: profile.getID()) { [weak self] in
            guard let self = self else {return}
            switch $0{
            case .success(let datas):
                self.datas = datas
                completion(Result.success(()))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func getRecruitmentData(completion: @escaping (Result<Void,Error>) -> Void) {
        profile.getRequest(className: "recruitment", objectID: profile.getID()) { [weak self] in
            guard let self = self else {return}
            switch $0{
            case .success(let datas):
                self.datas = datas
                completion(Result.success(()))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
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
    
    func countFollower(completion: @escaping (Result<Int,Error>) -> Void) {
        let userId = profile.getID()
        followModel.countFollow(field: "followedBy", userObjectId: userId) {
            switch $0{
            case .success(let data):
                completion(Result.success(data))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func countFollowing(completion: @escaping (Result<Int,Error>) -> Void) {
        let userId = profile.getID()
        followModel.countFollow(field: "followOn", userObjectId: userId) {
            switch $0{
            case .success(let int):
                completion(Result.success(int))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func countGoodNumber(completion: @escaping (Result<Int,Error>) -> Void) {
        let userId = profile.getID()
        followModel.countGoodNumber(userId: userId) {
            switch $0 {
            case .success(let count):
                completion(Result.success(count))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
}
