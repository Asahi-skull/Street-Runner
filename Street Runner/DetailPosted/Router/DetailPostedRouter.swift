//
//  DetailPostedRouter.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/17.
//

import Foundation
import UIKit

protocol DetailPostedRouter{
    func transition(idetifier: String,sender: Any?)
    func resultAlert(titleText: String, messageText: String, titleOK: String)
}

class DetailPostedRouterImpl: DetailPostedRouter{
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
