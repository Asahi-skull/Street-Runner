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
    func getUserProfile(imageView: UIImageView,completion: @escaping (Result<String,Error>) -> Void)
    func getRequestData(completion: @escaping (Result<Void,Error>) -> Void)
    func getRecruitmentData(completion: @escaping (Result<Void,Error>) -> Void)
    func dataCount() -> Int
    func getData(indexPath: IndexPath) -> ProfilePostedEntity
    func setImage(fileName: String,imageView: UIImageView)
}

class UserProfileViewModelImpl: UserProfileViewModel{
    init(userObjectId: String){
        self.userObjectId = userObjectId
    }
    
    let userObjectId: String
    private var datas: [ProfilePostedEntity] = []
    
    let userProfileModel: CommentMBaaS = CommentMBaaSImpl()
    let getImageModel: ShowPostedMBaaS = ShowPostedMBaaSImpl()
    let profileModel: ProfilemBaaS = ProfilemBaaSImpl()
    
    func getUserObjectId() -> String {
        userObjectId
    }
    
    func getUserProfile(imageView: UIImageView,completion: @escaping (Result<String,Error>) -> Void) {
        userProfileModel.getUserData(userObjectId: userObjectId) { result in
            switch result{
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
        profileModel.getRequest(className: "request", objectID: userObjectId) { result in
            switch result{
            case .success(let datas):
                self.datas = datas
                completion(Result.success(()))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func getRecruitmentData(completion: @escaping (Result<Void,Error>) -> Void) {
        profileModel.getRequest(className: "recruitment", objectID: userObjectId) { result in
            switch result{
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
}
