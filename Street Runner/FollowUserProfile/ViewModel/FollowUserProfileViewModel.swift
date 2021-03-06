//
//  FollowUserProfileViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2022/01/10.
//

import Foundation

protocol FollowUserProfileViewModel{
    func getUserObjectId() -> String
    func getCurrentUserObjectId() -> String
    func getUserProfile(completion: @escaping (Result<UserData,Error>) -> Void)
    func getRequestData(completion: @escaping (Result<Void,Error>) -> Void)
    func getRecruitmentData(completion: @escaping (Result<Void,Error>) -> Void)
    func dataCount() -> Int
    func getData(indexPath: IndexPath) -> ProfilePostedEntity
    func setImage(fileName: String,completion: @escaping (Result<Data,Error>) -> Void)
    func follow(completion: @escaping (Result<Void,Error>) -> Void)
    func unFollow(completion: @escaping (Result<Void,Error>) -> Void)
    func checkFollow() -> Result<Void,Error>
    func boolcheck() -> Bool
    func countFollower(completion: @escaping (Result<Int,Error>) -> Void)
    func countFollowing(completion: @escaping (Result<Int,Error>) -> Void)
    func push(completion: @escaping (Result<Void,Error>) -> Void)
    func countGoodNumber(completion: @escaping (Result<Int,Error>) -> Void)
}

class FollowUserProfileViewModelImpl: FollowUserProfileViewModel{
    init(userObjectId: String){
        self.userObjectId = userObjectId
    }
    
    private let userObjectId: String
    private var datas: [ProfilePostedEntity] = []
    private var check: Bool = false
    private let userProfileModel: CommentMBaaS = CommentMBaaSImpl()
    private let getImageModel: ShowPostedMBaaS = ShowPostedMBaaSImpl()
    private let profileModel: ProfilemBaaS = ProfilemBaaSImpl()
    private let followModel: UserProfileMBaaS = UserProfileMBaaSImpl()
    private let pushModel: PushMbaas = PushMbaasImpl()
    
    func getUserObjectId() -> String {
        userObjectId
    }
    
    func getCurrentUserObjectId() -> String {
        profileModel.getID()
    }
    
    func getUserProfile(completion: @escaping (Result<UserData,Error>) -> Void) {
        userProfileModel.getUserData(userObjectId: userObjectId) {
            switch $0{
            case .success(let data):
                completion(Result.success(data))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func getRequestData(completion: @escaping (Result<Void,Error>) -> Void) {
        profileModel.getRequest(className: "request", objectID: userObjectId) { [weak self] in
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
        profileModel.getRequest(className: "recruitment", objectID: userObjectId) { [weak self] in
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
    
    func dataCount() -> Int {
        datas.count
    }
    
    func getData(indexPath: IndexPath) -> ProfilePostedEntity {
        datas[indexPath.row]
    }
    
    func setImage(fileName: String,completion: @escaping (Result<Data,Error>) -> Void) {
        getImageModel.getIconImage(fileName: fileName) {
            switch $0 {
            case .success(let imageData):
                completion(Result.success(imageData))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func follow(completion: @escaping (Result<Void,Error>) -> Void) {
        let currentUserObjrctId = profileModel.getID()
        followModel.follow(followedBy: userObjectId, followOn: currentUserObjrctId) { [weak self] in
            guard let self = self else {return}
            switch $0{
            case .success:
                self.check = true
                completion(Result.success(()))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func unFollow(completion: @escaping (Result<Void,Error>) -> Void){
        let currentUserObjrctId = profileModel.getID()
        followModel.unFollow(followedBy: userObjectId, followOn: currentUserObjrctId) { [weak self] in
            guard let self = self else {return}
            switch $0 {
            case .success:
                self.check = false
                completion(Result.success(()))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func checkFollow() -> Result<Void,Error> {
        let currentUserObjrctId = profileModel.getID()
        switch followModel.checkFollow(followedBy: userObjectId, followOn: currentUserObjrctId){
        case .success(let int):
            if int == 0{
                check = false
            }else{
                check = true
            }
            return Result.success(())
        case .failure(let err):
            return Result.failure(err)
        }
    }
    
    func boolcheck() -> Bool {
        check
    }
    
    func countFollower(completion: @escaping (Result<Int,Error>) -> Void){
        followModel.countFollow(field: "followedBy", userObjectId: userObjectId) {
            switch $0{
            case .success(let int):
                completion(Result.success(int))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func countFollowing(completion: @escaping (Result<Int,Error>) -> Void){
        followModel.countFollow(field: "followOn", userObjectId: userObjectId) {
            switch $0{
            case .success(let int):
                completion(Result.success(int))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func push(completion: @escaping (Result<Void,Error>) -> Void) {
        let username = profileModel.getUser()
        let message = username + "にフォローされました"
        pushModel.push(title: "アプリからのメッセージ", message: message,category: "follow", userId: userObjectId) {
            switch $0{
            case .success:
                completion(Result.success(()))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func countGoodNumber(completion: @escaping (Result<Int,Error>) -> Void) {
        followModel.countGoodNumber(userId: userObjectId) {
            switch $0 {
            case .success(let count):
                completion(Result.success(count))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
}
