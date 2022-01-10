//
//  UserDetailViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2022/01/08.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: UserDetailViewModel?
    lazy var router: UserDetailRouter = UserDetailRouterImpl(viewController: self)
    
    var entity: detailData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let entity = entity {
            viewModel = UserDetailViewModelImpl(entity: entity)
        }else{
            router.resultAlert(titleText: "読み込み失敗", messageText: "再起動してください", titleOK: "OK")
        }
        let userNib = UINib(nibName: "DetailUserTableViewCell", bundle: nil)
        tableView.register(userNib, forCellReuseIdentifier: "detailUserCell")
        let imageNib = UINib(nibName: "DetailImagTableViewCell", bundle: nil)
        tableView.register(imageNib, forCellReuseIdentifier: "detailImageCell")
        let postedNib = UINib(nibName: "DetailPostedTableViewCell", bundle: nil)
        tableView.register(postedNib, forCellReuseIdentifier: "detailPostedCell")
        let commentNib = UINib(nibName: "DetailCommentTableViewCell", bundle: nil)
        tableView.register(commentNib, forCellReuseIdentifier: "detailCommentCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}

extension UserDetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailUserCell", for: indexPath) as! DetailUserTableViewCell
            viewModel?.getUserInfo {
                switch $0{
                case .success(let data):
                    guard let iconImageFile = data.iconImageFile else {return}
                    self.viewModel?.getImage(fileName: iconImageFile, imageView: cell.iconImage)
                    guard let userName = data.userName else {return}
                    cell.setData(userName: userName)
                case .failure:
                    return
                }
            }
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailImageCell", for: indexPath) as! DetailImagTableViewCell
            guard let imageFileName = entity?.requestImage else {return cell}
            viewModel.map{
                $0.getImage(fileName: imageFileName, imageView: cell.postedImage)
            }
            return cell
        }else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailPostedCell", for: indexPath) as! DetailPostedTableViewCell
            if let entityData = viewModel?.getEntity(){
                guard let postedText = entityData.requestText else {return cell}
                cell.postedText.text = postedText
                cell.setData(entity: entityData)
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCommentCell", for: indexPath) as! DetailCommentTableViewCell
            return cell
        }
    }
}

extension UserDetailViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return tableView.bounds.height/10
        }else if indexPath.row == 1{
            return tableView.bounds.height * 3/7
        }else if indexPath.row == 2{
            return tableView.bounds.height - tableView.bounds.height/5 - tableView.bounds.height * 3/7
        }else{
            return tableView.bounds.height/10
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0{
            navigationController?.popViewController(animated: true)
        }else if indexPath.row == 1{
        }else if indexPath.row == 2{
        }else{
            viewModel.map{
                router.transition(idetifier: "userToComment", sender: $0.getEntity())
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let entityItem = sender as! detailData
        let userToComment = segue.destination as! UserCommentListViewController
        let commentData = commentData(objectId: entityItem.objectID, userObjectId: entityItem.userObjectID, className: entityItem.className)
        userToComment.entity = commentData
    }
}
