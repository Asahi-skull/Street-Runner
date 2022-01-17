//
//  ShowPostedViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/05.
//

import Foundation

protocol ShowPostedViewModel{
    func dataCount() -> Int
    func getData(indexPath: IndexPath) -> RequestEntity
    func getRequestData(completion: @escaping (Result<Void,Error>) -> Void)
    func getRecruitmentData(completion: @escaping (Result<Void,Error>) -> Void)
    func getIconImage(fileName: String,completion: @escaping (Result<Data,Error>) -> Void)
    func getUserInfo(userObjectId: String, completion: @escaping (Result<UserData,Error>) -> Void)
}

class ShowPostedViewModelImpl: ShowPostedViewModel{
    private let showPosted: ShowPostedMBaaS = ShowPostedMBaaSImpl()
    private let userInfo: CommentMBaaS = CommentMBaaSImpl()
    private var datas: [RequestEntity] = []
    
    func dataCount() -> Int {
        datas.count
    }
    
    func getData(indexPath: IndexPath) -> RequestEntity {
        datas[indexPath.row]
    }
    
    func getRequestData(completion: @escaping (Result<Void,Error>) -> Void) {
        showPosted.getRequest(className: "request") { [weak self] in
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
        showPosted.getRequest(className: "recruitment") { [weak self] in
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
    
    func getIconImage(fileName: String,completion: @escaping (Result<Data,Error>) -> Void) {
        showPosted.getIconImage(fileName: fileName) {
            switch $0 {
            case .success(let imageData):
                completion(Result.success(imageData))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func getUserInfo(userObjectId: String, completion: @escaping (Result<UserData,Error>) -> Void){
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
