//
//  FavoritePostsViewController.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 04.08.2022.
//

import UIKit

class FavoritePostsViewController: UIViewController {
    //MARK: - Views
    private let tableView = UITableView()
    
    //MARK: - Private properties
    private let postModel: AllPostsModel = .init()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureModel()
        postModel.loadPosts()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
}
//MARK: - Private methods
private extension FavoritePostsViewController {
    func configureAppearance() {
        configureTableView()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "Избранное"
        let searchButton = UIBarButtonItem(image: UIImage(named: "searchBar"),
                                         style: .plain,
                                         target: self,
                                           action: #selector(goToSearchVC(sender:)))
        navigationItem.rightBarButtonItem = searchButton
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    func configureModel() {
        postModel.didPostsUpdated = { [weak self] in
            DispatchQueue.main.async {
                 self?.tableView.reloadData()
             }
        }
    }
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        tableView.register(UINib(nibName: "\(DetailedPostImageTableViewCell.self)", bundle: .main), forCellReuseIdentifier: "\(DetailedPostImageTableViewCell.self)")
        tableView.register(UINib(nibName: "\(DetailedPostTitleTableViewCell.self)", bundle: .main), forCellReuseIdentifier: "\(DetailedPostTitleTableViewCell.self)")
        tableView.register(UINib(nibName: "\(DetailedPostBodyShortedTableViewCell.self)", bundle: .main), forCellReuseIdentifier: "\(DetailedPostBodyShortedTableViewCell.self)")
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    @objc func goToSearchVC(sender: UIBarButtonItem) {
        let vc = SearchPostsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - TableView DataSource
extension FavoritePostsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return postModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(DetailedPostImageTableViewCell.self)")
            if let cell = cell as? DetailedPostImageTableViewCell {
                cell.imageUrlInString = postModel.posts[indexPath.section].imageUrlInString
                cell.isFavorite = true
            }
            return cell ?? UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(DetailedPostTitleTableViewCell.self)")
            if let cell = cell as? DetailedPostTitleTableViewCell {
                cell.titleText = postModel.posts[indexPath.section].title
                cell.titleDate = postModel.posts[indexPath.section].dateCreation
            }
            return cell ?? UITableViewCell()
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(DetailedPostBodyShortedTableViewCell.self)")
            if let cell = cell as? DetailedPostBodyShortedTableViewCell {
                cell.bodyText = postModel.posts[indexPath.section].content
            }
            return cell ?? UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
}

