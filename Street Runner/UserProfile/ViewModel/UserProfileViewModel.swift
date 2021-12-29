//
//  UserProfileViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/25.
//

import Foundation
import UIKit

protocol UserProfileViewModel{
    func getUserObjectId() -> String
    func getCurrentUserObjectId() -> String
    func getUserProfile(imageView: UIImageView,completion: @escaping (Result<String,Error>) -> Void)
    func getRequestData(completion: @escaping (Result<Void,Error>) -> Void)
    func getRecruitmentData(completion: @escaping (Result<Void,Error>) -> Void)
    func dataCount() -> Int
    func getData(indexPath: IndexPath) -> ProfilePostedEntity
    func setImage(fileName: String,imageView: UIImageView)
    func follow(completion: @escaping (Result<Void,Error>) -> Void)
    func unFollow(completion: @escaping (Result<Void,Error>) -> Void)
    func checkFollow() -> Result<Void,Error>
    func boolcheck() -> Bool
}

class UserProfileViewModelImpl: UserProfileViewModel{
    init(userObjectId: String){
        self.userObjectId = userObjectId
    }
    
    let userObjectId: String
    private var datas: [ProfilePostedEntity] = []
    private var check: Bool = false
    
    let userProfileModel: CommentMBaaS = CommentMBaaSImpl()
    let getImageModel: ShowPostedMBaaS = ShowPostedMBaaSImpl()
    let profileModel: ProfilemBaaS = ProfilemBaaSImpl()
    let followModel: UserProfileMBaaS = UserProfileMBaaSImpl()
    
    func getUserObjectId() -> String {
        userObjectId
    }
    
    func getCurrentUserObjectId() -> String {
        profileModel.getID()
    }
    
    func getUserProfile(imageView: UIImageView,completion: @escaping (Result<String,Error>) -> Void) {
        userProfileModel.getUserData(userObjectId: userObjectId) {
            switch $0{
            case .success(let data):
                guard let fileName = data.iconImageFile else {return}
                self.getImageModel.getIconImage(fileName: fileName, imageView: imageView)
                guard let userName = data.userName else {return}
                completion(Result.success(userName))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func getRequestData(completion: @escaping (Result<Void,Error>) -> Void) {
        profileModel.getRequest(className: "request", objectID: userObjectId) {
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
        profileModel.getRequest(className: "recruitment", objectID: userObjectId) {
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
    
    func setImage(fileName: String,imageView: UIImageView) {
        getImageModel.getIconImage(fileName: fileName, imageView: imageView)
    }
    
    func follow(completion: @escaping (Result<Void,Error>) -> Void) {
        let currentUserObjrctId = profileModel.getID()
        followModel.follow(followedBy: userObjectId, followOn: currentUserObjrctId) {
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
        followModel.unFollow(followedBy: userObjectId, followOn: currentUserObjrctId) {
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
}
