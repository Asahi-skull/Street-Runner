//
//  GuestViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/20.
//

import UIKit

class GuestViewController: UIViewController {
    
    let viewModel: GuestViewModel = GuestViewModelImpl()
    lazy var router: GuestRouter = GuestRouterImpl(viewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.autoLogin(){
            router.transition(idetifier: "fromGuest")
        }
    }

    @IBAction func registerButton(_ sender: Any) {
        router.transition(idetifier: "toSignUp")
    }
    
}
