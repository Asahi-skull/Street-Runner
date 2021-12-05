//
//  ShowPostedViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/04.
//

import UIKit

class ShowPostedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel: ShowPostedViewModel = ShowPostedViewModelImpl()
    lazy var router: ShowPostedRouter = ShowPostedRouterImpl(viewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let SegmentedNib = UINib(nibName: "SegmentedTableCell", bundle: nil)
        tableView.register(SegmentedNib, forCellReuseIdentifier: "segmentedCell")
        let PostedTableNib = UINib(nibName: "ShowPostedTableCell", bundle: nil)
        tableView.register(PostedTableNib, forCellReuseIdentifier: "postedCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let result = viewModel.getRequestData()
        switch result{
        case .success:
            tableView.reloadData()
        case .failure:
            router.resultAlert(titleText: "読み込みに失敗", messageText: "アプリを再起動してください", titleOK: "OK")
        }
    }
}

extension ShowPostedViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "segmentedCell", for: indexPath) as! SegmentedTableCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "postedCell", for: indexPath) as! ShowPostedTableCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 40
        }else{
            return 700
        }
    }
}

extension ShowPostedViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.dataCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postedCollectionCell", for: indexPath) as! ShowPostedCollectionCell
        let data = viewModel.getData(indexPath: indexPath)
        cell.userNameLabel.text = data.userName
        cell.contentTextLabel.text = data.requestText
        guard let iconFileName = data.userObjectID else {return cell}
        let iconResult = viewModel.getIconImage(fileName: iconFileName)
        switch iconResult{
        case .success(let Image):
            cell.iconImage.image = Image
        case .failure:
            break
        }
        guard let requestFileName = data.requestImage else {return cell}
        let requestResult = viewModel.getIconImage(fileName: requestFileName)
        switch requestResult{
        case .success(let Image):
            cell.requestImage.image = Image
        case .failure:
            break
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace: CGFloat = 10
        let cellSize: CGFloat = self.view.bounds.width/2 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize + 50)
    }
}
