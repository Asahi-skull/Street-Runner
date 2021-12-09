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
        let segmentedNib = UINib(nibName: "SegmentedTableCell", bundle: nil)
        tableView.register(segmentedNib, forCellReuseIdentifier: "segmentedCell")
        let postedTableNib = UINib(nibName: "ShowPostedTableCell", bundle: nil)
        tableView.register(postedTableNib, forCellReuseIdentifier: "postedCell")
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
            cell.segmented.addTarget(self, action: #selector(self.segmentChanged(_:)), for: .valueChanged)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "postedCell", for: indexPath) as! ShowPostedTableCell
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 40
        }else{
            return tableView.bounds.height - 40
        }
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("First")
            break
        case 1:
            print("Second")
            break
        default:
            break
        }
    }
}

extension ShowPostedViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.dataCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postedCollectionCell", for: indexPath) as! ShowPostedCollectionCell
        let data = viewModel.getData(indexPath: indexPath)
        guard let userName = data.userName else {return cell}
        cell.userNameLabel.text = userName
        guard let requestText = data.requestText else {return cell}
        cell.contentTextLabel.text = requestText
        guard let iconFileName = data.userObjectID else {return cell}
        viewModel.getIconImage(fileName: iconFileName, imageView: cell.iconImage)
        guard let requestFileName = data.requestImage else {return cell}
        viewModel.getIconImage(fileName: requestFileName, imageView: cell.requestImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace: CGFloat = 10
        let cellSize: CGFloat = self.tableView.bounds.width/2 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize + 150)
    }
}
