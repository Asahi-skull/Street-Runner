//
//  PostRequestRouter.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/02.
//

import Foundation
import UIKit

protocol PostRequestRouter{
    func backView()
    func resultAlert(titleText: String, messageText: String, titleOK: String)
}

class PostRequestRouterImpl: PostRequestRouter{
    private let viewController: UIViewController
    init(viewController: UIViewController){
        self.viewController = viewController
    }
    
    func backView() {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func resultAlert(titleText: String, messageText: String, titleOK: String) {
        let alertController = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: titleOK, style: .default, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
}
