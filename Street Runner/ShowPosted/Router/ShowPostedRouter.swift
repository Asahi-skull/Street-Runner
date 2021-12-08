//
//  ShowPostedRouter.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/05.
//

import Foundation
import UIKit

protocol ShowPostedRouter{
    func resultAlert(titleText: String, messageText: String, titleOK: String)
}

class ShowPostedRouterImpl: ShowPostedRouter{
    let viewController: UIViewController
    init(viewController :UIViewController){
        self.viewController = viewController
    }
    
    func resultAlert(titleText: String, messageText: String, titleOK: String) {
        let alertController = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: titleOK, style: .default, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
}
