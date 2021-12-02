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
}

class SelectPostRouterImpl: SelectPostRouter{
    let viewController:UIViewController
    init(viewController:UIViewController){
        self.viewController = viewController
    }
    
    func transition(idetifier: String) {
        viewController.performSegue(withIdentifier: idetifier, sender: nil)
    }
}
