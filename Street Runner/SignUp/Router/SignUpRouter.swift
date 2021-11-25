//
//  SignUpRouter.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/24.
//

import Foundation
import UIKit

protocol SignUpRouter{
    func resultAlert(titleText: String, messageText: String, titleOK: String)
    func transition(idetifier: String)
}

class SignUpRouterImpl: SignUpRouter{
    let viewController:UIViewController
    init(viewController:UIViewController){
        self.viewController = viewController
    }
    
    func resultAlert(titleText: String, messageText: String, titleOK: String) {
        let alertController = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: titleOK, style: .default, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func transition(idetifier: String) {
        viewController.performSegue(withIdentifier: idetifier, sender: nil)
    }
}
