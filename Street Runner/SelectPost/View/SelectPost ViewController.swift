//
//  PostImageViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/30.
//

import UIKit

class SelectPostViewController: UIViewController{
    
    private let viewModel: SelectPostViewModel = SelectPostViewModelImpl()
    private lazy var router: PerformAlertRouter = PerformAlertRouterImpl(viewController: self)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SelectPostViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectCell", for: indexPath)
        let selectLabel = cell.viewWithTag(1) as! UILabel
        if indexPath.row == 0{
            selectLabel.text = "依頼を投稿する　＞"
            return cell
        }else{
            selectLabel.text = "募集を投稿する　＞"
            return cell
        }
    }
}

extension SelectPostViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.bounds.height/2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if viewModel.checkUserExist() {
            if indexPath.row == 0{
                router.transition(idetifier: "toPostRequest",sender: nil)
            }else{
                router.transition(idetifier: "toPostRecruitment",sender: nil)
            }
        }else{
            router.changeViewAfterAlert(titleText: "ログインしないと投稿できません", messageText: "", titleOK: "OK")
        }
    }
}
extension SelectPostViewController: AlertResult{
    func changeView() {
        router.changeTabBar(tabNum: 2)
    }
}
