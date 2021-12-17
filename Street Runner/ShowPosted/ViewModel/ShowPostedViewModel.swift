//
//  ShowPostedViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/05.
//

import Foundation
import UIKit

protocol ShowPostedViewModel{
    func dataCount() -> Int
    func getData(indexPath: IndexPath) -> RequestEntity
    func getRequestData(completion: @escaping (Result<Void,Error>) -> Void)
    func getRecruitmentData(completion: @escaping (Result<Void,Error>) -> Void)
    func getIconImage(fileName: String,imageView: UIImageView)
}

class ShowPostedViewModelImpl: ShowPostedViewModel{
    let showPosted: ShowPostedMBaaS = ShowPostedMBaaSImpl()
    private var datas: [RequestEntity] = []
    
    func dataCount() -> Int {
        datas.count
    }
    
    func getData(indexPath: IndexPath) -> RequestEntity {
        datas[indexPath.row]
    }
    
    func getRequestData(completion: @escaping (Result<Void,Error>) -> Void) {
        showPosted.getRequest(className: "request") { result in
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
        showPosted.getRequest(className: "recruitment") { result in
            switch result{
            case .success(let datas):
                self.datas = datas
                completion(Result.success(()))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func getIconImage(fileName: String,imageView: UIImageView){
        showPosted.getIconImage(fileName: fileName, imageView: imageView)
    }
}
