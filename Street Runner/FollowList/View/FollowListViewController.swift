//
//  FollowListViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2022/01/03.
//

import UIKit

class FollowListViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel: FollowListViewModel = FollowListViewModelImpl()
    lazy var router: FollowListRouter = FollowListRouterImpl(viewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "FollowListTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "followListCell")
        self.segmentControl.addTarget(self, action: #selector(self.segmentChanged(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFollowerData { [weak self] in
            guard let self = self else {return}
            switch $0 {
            case .success:
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure:
                DispatchQueue.main.async {
                    self.router.resultAlert(titleText: "データの取得に失敗", messageText: "再試行してください", titleOK: "OK")
                }
            }
        }
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.getFollowerData { [weak self] in
                guard let self = self else {return}
                switch $0 {
                case .success:
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure:
                    DispatchQueue.main.async {
                        self.router.resultAlert(titleText: "データの取得に失敗", messageText: "再試行してください", titleOK: "OK")
                    }
                }
            }
        case 1:
            viewModel.getFollowingData { [weak self] in
                guard let self = self else {return}
                switch $0 {
                case .success:
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure:
                    DispatchQueue.main.async {
                        self.router.resultAlert(titleText: "データの取得に失敗", messageText: "再試行してください", titleOK: "OK")
                    }
                }
            }
        default:
            break
        }
    }
}

extension FollowListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followListCell", for: indexPath) as! FollowListTableViewCell
        let data = viewModel.getData(indexPath: indexPath)
        viewModel.getUserData(userObjectId: data) {
            switch $0 {
            case .success(let datas):
                guard let ImageFile = datas.iconImageFile else {return}
                self.viewModel.setIconImage(fileName: ImageFile, imageView: cell.iconImage)
                guard let userName = datas.userName else {return}
                DispatchQueue.main.async {
                    cell.userNameLabel.text = userName
                }
            case .failure:
                return
            }
        }
        return cell
    }
}

extension FollowListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.bounds.height/8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        router.transition(idetifier: "followToProfile", sender: viewModel.getData(indexPath:indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let userId = sender as? String{
            let followToProfile = segue.destination as!  FollowUserProfileViewController
            followToProfile.userObjectId = userId
        }
    }
}
