//
//  FollowDetailViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2022/01/11.
//

import UIKit

class FollowDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: FollowDetailViewModel?
    private lazy var router: FollowDetailRouter = FollowDetailRouterImpl(viewController: self)
    var entity: detailData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let entity = entity {
            viewModel = FollowDetailViewModelImpl(entity: entity)
        }else{
            router.resultAlert(titleText: "データの取得に失敗", messageText: "戻る", titleOK: "OK")
            navigationController?.popViewController(animated: true)
            return
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

extension FollowDetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailUserCell", for: indexPath) as! DetailUserTableViewCell
            viewModel.map{
                $0.getUserInfo {
                    switch $0{
                    case .success(let data):
                        guard let iconImageFile = data.iconImageFile else {return}
                        self.viewModel.map{
                            $0.getImage(fileName: iconImageFile, imageView: cell.iconImage)
                        }
                        guard let userName = data.userName else {return}
                        cell.setData(userName: userName)
                    case .failure:
                        return
                    }
                }
            }
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailImageCell", for: indexPath) as! DetailImagTableViewCell
            viewModel.map{
                guard let imageFileName = $0.getEntity().requestImage else {return}
                $0.getImage(fileName: imageFileName, imageView: cell.postedImage)
            }
            return cell
        }else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailPostedCell", for: indexPath) as! DetailPostedTableViewCell
            viewModel.map{
                guard let postedText = $0.getEntity().requestText else {return}
                cell.postedText.text = postedText
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCommentCell", for: indexPath) as! DetailCommentTableViewCell
            return cell
        }
    }
}

extension FollowDetailViewController: UITableViewDelegate{
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
                router.transition(idetifier: "followToComment", sender: $0.getEntity())
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let entityItem = sender as? detailData{
            let followToComment = segue.destination as! FollowCommentListViewController
            let commentData = commentData(objectId: entityItem.objectID, userObjectId: entityItem.userObjectID, className: entityItem.className)
            followToComment.entity = commentData
        }
    }
}

