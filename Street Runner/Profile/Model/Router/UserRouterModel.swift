//
//  UserRouterModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/22.
//

import Foundation
import UIKit

protocol UserRouterModel{
    
    func resultAlert(titleText: String, messageText: String, titleOK: String)
    func transition(idetifier: String)
}

class UserRouterModelImpl: UIViewController, UserRouterModel{
   
    func resultAlert(titleText: String, messageText: String, titleOK: String) {
        let alertController = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: titleOK, style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func transition(idetifier: String) {
        performSegue(withIdentifier: idetifier, sender: nil)
    }
}
