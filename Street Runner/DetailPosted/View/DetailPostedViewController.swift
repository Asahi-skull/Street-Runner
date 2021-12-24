//
//  DetailPostedViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/13.
//

import UIKit

class DetailPostedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: DetailPostedViewModel?
    lazy var router: DetailPostedRouter = DetailPostedRouterImpl(viewController: self)
    
    var entity: detailData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let entity = entity {
            viewModel = DetailPostedViewModelImpl(entity: entity)
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

extension DetailPostedViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailUserCell", for: indexPath) as! DetailUserTableViewCell
            viewModel?.getUserInfo(compltion: { result in
                switch result{
                case .success(let data):
                    guard let iconImageFile = data.iconImageFile else {return}
                    self.viewModel?.getImage(fileName: iconImageFile, imageView: cell.iconImage)
                    guard let userName = data.userName else {return}
                    cell.setData(userName: userName)
                case .failure:
                    return
                }
            })
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailImageCell", for: indexPath) as! DetailImagTableViewCell
            guard let imageFileName = entity?.requestImage else {return cell}
            viewModel?.getImage(fileName: imageFileName, imageView: cell.postedImage)
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
            router.transition(idetifier: "toUserProfile", sender: entity)
        }else if indexPath.row == 1{
            
        }else if indexPath.row == 2{
            
        }else{
            router.transition(idetifier: "toCommentList", sender: entity)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let entityItem = sender as! detailData
        let toCommentList = segue.destination as! CommentListViewController
        let commentData = commentData(objectId: entityItem.objectID, userObjectId: entityItem.userObjectID, className: entityItem.className)
        toCommentList.entity = commentData
    }
}
