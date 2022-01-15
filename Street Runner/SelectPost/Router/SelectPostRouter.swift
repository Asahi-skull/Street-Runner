//
//  SelectPostRouter.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/01.
//

import Foundation
import UIKit

protocol SelectPostRouter{
    func transition(idetifier: String)
    func resultAlert(titleText: String, messageText: String, titleOK: String)
}

class SelectPostRouterImpl: SelectPostRouter{
    private let viewController: UIViewController
    init(viewController:UIViewController){
        self.viewController = viewController
    }
    
    func transition(idetifier: String) {
        viewController.performSegue(withIdentifier: idetifier, sender: nil)
    }
    
    func resultAlert(titleText: String, messageText: String, titleOK: String) {
        (viewController as? RouterResult).map{ selectPostViewController in
            let alertController = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: titleOK, style: .default) {_ in
                selectPostViewController.ok()
            })
            viewController.present(alertController, animated: true) {
//                selectPostViewController.toGuestView()
            }
        }
    }
//        let alertController = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: titleOK, style: .default, handler: nil))
//        viewController.present(alertController, animated: true, completion: nil)
}
