//
//  GuestViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/20.
//

import UIKit

class GuestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func registerButton(_ sender: Any) {
        performSegue(withIdentifier: "toSignUp", sender: nil)
    }
    
}
