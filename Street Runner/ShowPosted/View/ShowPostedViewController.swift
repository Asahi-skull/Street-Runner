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
    
    private  var ncmbClass: String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let segmentedNib = UINib(nibName: "HomeSegmentedTableViewCell", bundle: nil)
        tableView.register(segmentedNib, forCellReuseIdentifier: "homeSegmentedCell")
        let postedTableNib = UINib(nibName: "ShowPostedTableCell", bundle: nil)
        tableView.register(postedTableNib, forCellReuseIdentifier: "postedCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getRequestData { [weak self] in
            guard let self = self else {return}
            switch $0{
            case .success:
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.ncmbClass = "request"
            case .failure:
                DispatchQueue.main.async {
                    self.router.resultAlert(titleText: "読み込みに失敗", messageText: "アプリを再起動してください", titleOK: "OK")
                }
            }
        }
    }
}

extension ShowPostedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeSegmentedCell", for: indexPath) as! HomeSegmentedTableViewCell
            cell.segmented.addTarget(self, action: #selector(self.segmentChanged(_:)), for: .valueChanged)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "postedCell", for: indexPath) as! ShowPostedTableCell
            cell.collectionView.reloadData()
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            return cell
        }
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.getRequestData { [weak self] in
                guard let self = self else {return}
                switch $0{
                case .success:
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    self.ncmbClass = "request"
                case .failure:
                    DispatchQueue.main.async{
                        self.router.resultAlert(titleText: "読み込みに失敗", messageText: "再試行してください", titleOK: "OK")
                    }
                }
            }
        case 1:
            viewModel.getRecruitmentData { [weak self] in
                guard let self = self else {return}
                switch $0{
                case .success:
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    self.ncmbClass = "recruitment"
                case .failure:
                    DispatchQueue.main.async{
                        self.router.resultAlert(titleText: "読み込みに失敗", messageText: "再試行してください", titleOK: "OK")
                    }
                }
            }
        default:
            break
        }
    }
}

extension ShowPostedViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return tableView.bounds.height/18
        }else{
            return tableView.bounds.height - tableView.bounds.height/18
        }
    }
}

extension ShowPostedViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.dataCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postedCollectionCell", for: indexPath) as! ShowPostedCollectionCell
         let data = viewModel.getData(indexPath: indexPath)
        guard let requestText = data.requestText else {return cell}
        cell.contentTextLabel.text = requestText
        guard let requestFileName = data.requestImage else {return cell}
        viewModel.getIconImage(fileName: requestFileName, imageView: cell.requestImage)
        
        guard let userObjectId = data.userObjectID else {return cell}
        viewModel.getUserInfo(userObjectId: userObjectId) { [weak self] in
            guard let self = self else {return}
            switch $0{
            case .success(let datas):
                DispatchQueue.main.async {
                    cell.userNameLabel.text = datas.userName
                }
                guard let iconImageFile = datas.iconImageFile else {return}
                self.viewModel.getIconImage(fileName: iconImageFile, imageView: cell.iconImage)
            case .failure:
                return
            }
        }
        return cell
    }
}

extension ShowPostedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router.transition(idetifier: "toDetailPosted", sender: viewModel.getData(indexPath:indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let entity = sender as! RequestEntity
        let toDetailPosted = segue.destination as! DetailPostedViewController
        let data = detailData(objectID: entity.objectID, requestImage: entity.requestImage, requestText: entity.requestText, userObjectID: entity.userObjectID, className: ncmbClass)
        toDetailPosted.entity = data
    }
}

extension ShowPostedViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace: CGFloat = 5
        let cellSize: CGFloat = self.tableView.bounds.width/2 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize + cellSize * 3/4)
    }
}
