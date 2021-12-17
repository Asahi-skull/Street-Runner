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
    
    var entity: RequestEntity?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let entity = entity {
            viewModel = DetailPostedViewModelImpl(entity: entity)
        }else{
            router.resultAlert(titleText: "読み込み失敗", messageText: "再起動してください", titleOK: "OK")
        }
        let userNib = UINib(nibName: "DetailUserTableViewCell", bundle: nil)
        tableView.register(userNib, forCellReuseIdentifier: "detailUserCell")
        let postedNib = UINib(nibName: "DetailPostedTableViewCell", bundle: nil)
        tableView.register(postedNib, forCellReuseIdentifier: "detailPostedCell")
    }
}

extension DetailPostedViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailUserCell", for: indexPath) as! DetailUserTableViewCell
            if let entityData = viewModel?.getEntity(){
                guard let iconFileName = entityData.userObjectID else {return cell}
                viewModel?.getImage(fileName: iconFileName, imageView: cell.iconImage)
                cell.setData(entity: entityData)
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailPostedCell", for: indexPath) as! DetailPostedTableViewCell
            guard let imageFileName = entity?.requestImage else {return cell}
            viewModel?.getImage(fileName: imageFileName, imageView: cell.postedImage)
            if let entityData = viewModel?.getEntity(){
                guard let postedText = entityData.requestText else {return cell}
                cell.postedText.text = postedText
                cell.setData(entity: entityData)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 60
        }else{
            return 300
        }
    }
}
