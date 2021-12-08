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
    func getRequestData() -> Result<Void,Error>
    func getIconImage(fileName: String) -> Result<UIImage,Error>
}

class ShowPostedViewModelImpl: ShowPostedViewModel{
    let model: ShowPostedModel = ShowPostedModelImpl()
    private var datas: [RequestEntity] = []
    
    func dataCount() -> Int {
        datas.count
    }
    
    func getData(indexPath: IndexPath) -> RequestEntity {
        datas[indexPath.row]
    }
    
    func getRequestData() -> Result<Void, Error> {
        let result = model.getRequest(className: "request")
        switch result{
        case .success(let datas):
            self.datas = datas
            return Result.success(())
        case .failure(let err):
            return Result.failure(err)
        }
    }
    
    func getIconImage(fileName: String) -> Result<UIImage,Error>{
        model.getIconImage(fileName: fileName)
    }
}
