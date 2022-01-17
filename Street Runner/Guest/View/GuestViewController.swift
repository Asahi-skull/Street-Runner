//
//  GuestViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/20.
//

import UIKit

class GuestViewController: UIViewController {
    
    private let viewModel: GuestViewModel = GuestViewModelImpl()
    private lazy var router: PerformAlertRouter = PerformAlertRouterImpl(viewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.autoLogin(){
            router.transition(idetifier: "fromGuest",sender: nil)
        }
    }

    @IBAction func registerButton(_ sender: Any) {
        router.transition(idetifier: "toSignUp",sender: nil)
    }
    
    @IBAction func unwindToGuest(_ unwindSegue: UIStoryboardSegue) {
    }
}
