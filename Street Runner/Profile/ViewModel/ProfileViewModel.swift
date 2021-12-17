//
//  ProfileViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/22.
//

import Foundation
import UIKit

protocol ProfileViewModel{
    func setUser() -> String
    func getIconImage() -> Result<UIImage,Error>
    func dataCount() -> Int
    func getData(indexPath: IndexPath) -> ProfilePostedEntity
    func getRequest(completion: @escaping (Result<Void,Error>) -> Void)
    func getRecruitmentData(completion: @escaping (Result<Void,Error>) -> Void)
    func getImage(fileName: String,imageView: UIImageView)
}

class ProfileViewModelImpl: ProfileViewModel{
    let profile: ProfilemBaaS = ProfilemBaaSImpl()
    let showPosted: ShowPostedMBaaS = ShowPostedMBaaSImpl()
    private var datas: [ProfilePostedEntity] = []
    
    func setUser() -> String {
        profile.getUser()
    }
    
    func getIconImage() -> Result<UIImage,Error>{
        let fileName = profile.getID()
        let imageResult = profile.getIconImage(fileName: fileName)
        return imageResult
    }
    
    func dataCount() -> Int {
        datas.count
    }
    
    func getData(indexPath: IndexPath) -> ProfilePostedEntity {
        datas[indexPath.row]
    }
    
    func getRequest(completion: @escaping (Result<Void,Error>) -> Void) {
        profile.getRequest(className: "request", objectID: profile.getID()) { result in
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
        profile.getRequest(className: "recruitment", objectID: profile.getID()) { result in
            switch result{
            case .success(let datas):
                self.datas = datas
                completion(Result.success(()))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func getImage(fileName: String,imageView: UIImageView){
        showPosted.getIconImage(fileName: fileName, imageView: imageView)
    }
}
