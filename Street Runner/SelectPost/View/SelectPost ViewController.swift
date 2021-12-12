//
//  PostImageViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/30.
//

import UIKit

class SelectPostViewController: UIViewController{
    
    lazy var router: SelectPostRouter = SelectPostRouterImpl(viewController: self)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func requestButton(_ sender: Any) {
        router.transition(idetifier: "toPostRequest")
    }
    
    @IBAction func RecruitmentButton(_ sender: Any) {
        router.transition(idetifier: "toPostRecruitment")
    }
}

