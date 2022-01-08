//
//  UserDetailRouter.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2022/01/08.
//

import Foundation
import UIKit

protocol UserDetailRouter{
    func transition(idetifier: String,sender: Any?)
    func resultAlert(titleText: String, messageText: String, titleOK: String)
}

class UserDetailRouterImpl: UserDetailRouter{
    let viewController: UIViewController
    init(viewController :UIViewController){
        self.viewController = viewController
    }
    
    func transition(idetifier: String,sender: Any?) {
        viewController.performSegue(withIdentifier: idetifier, sender: sender)
    }
    
    func resultAlert(titleText: String, messageText: String, titleOK: String) {
        let alertController = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: titleOK, style: .default, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
}
