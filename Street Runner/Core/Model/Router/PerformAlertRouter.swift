//
//  PerformAlertRouter.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2022/01/16.
//

import Foundation
import UIKit

protocol PerformAlertRouter{
    func transition(idetifier: String,sender: Any?)
    func resultAlert(titleText: String, messageText: String, titleOK: String)
    func changeViewAfterAlert(titleText: String, messageText: String, titleOK: String)
    func dismiss()
    func popBackView()
    func changeTabBar(tabNum: Int)
}

class PerformAlertRouterImpl: PerformAlertRouter{
    private let viewController: UIViewController
    
    init(viewController: UIViewController){
        self.viewController = viewController
    }
    
    func transition(idetifier: String,sender: Any?) {
        viewController.performSegue(withIdentifier: idetifier, sender: sender)
    }
    
    func resultAlert(titleText: String,messageText: String,titleOK: String) {
        let alertController = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: titleOK, style: .default, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func changeViewAfterAlert(titleText: String,messageText: String,titleOK: String) {
        (viewController as? AlertResult).map{ AlertResultProtcol in
            let alertController = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: titleOK, style: .default) {_ in
                AlertResultProtcol.changeView()
            })
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    func dismiss() {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func popBackView() {
        viewController.navigationController?.popViewController(animated: true)
    }
    
    func changeTabBar(tabNum: Int) {
        let guestView = viewController.tabBarController?.viewControllers?[tabNum]
        viewController.tabBarController?.selectedViewController = guestView
    }
}
