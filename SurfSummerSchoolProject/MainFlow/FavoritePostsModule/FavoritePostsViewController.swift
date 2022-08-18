//
//  FavoritePostsViewController.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 04.08.2022.
//

import UIKit

class FavoritePostsViewController: UIViewController {
    //MARK: Constants
    private let searchBar: UIImage? = ImagesStorage.searchBar
    
    private let detailedPostImageTableViewCell: String = "\(DetailedPostImageTableViewCell.self)"
    private let detailedPostTitleTableViewCell: String = "\(DetailedPostTitleTableViewCell.self)"
    private let detailedPostBodyShortedTableViewCell: String = "\(DetailedPostBodyShortedTableViewCell.self)"
    
    private let numberOfRows = 3
    //MARK: - Views
    private let tableView = UITableView()
    
    //MARK: - Singleton instances
    private let postModel: AllPostsModel = AllPostsModel.shared
    
    //MARK: - Public properties
    static var favoriteTapStatus: Bool = false
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        if FavoritePostsViewController.favoriteTapStatus {
            tableView.reloadData()
            FavoritePostsViewController.favoriteTapStatus = false
        }
    }
}
//MARK: - Private methods
private extension FavoritePostsViewController {
    func configureAppearance() {
        configureTableView()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "Избранное"
        let searchButton = UIBarButtonItem(image: searchBar,
                                           style: .plain,
                                           target: self,
                                           action: #selector(goToSearchVC(sender:)))
        navigationItem.rightBarButtonItem = searchButton
        navigationItem.rightBarButtonItem?.tintColor = ColorsStorage.black
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
        tableView.register(UINib(nibName: detailedPostImageTableViewCell, bundle: .main), forCellReuseIdentifier: detailedPostImageTableViewCell)
        tableView.register(UINib(nibName: detailedPostTitleTableViewCell, bundle: .main), forCellReuseIdentifier: detailedPostTitleTableViewCell)
        tableView.register(UINib(nibName: detailedPostBodyShortedTableViewCell, bundle: .main), forCellReuseIdentifier: detailedPostBodyShortedTableViewCell)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    @objc func goToSearchVC(sender: UIBarButtonItem) {
        let vc = SearchPostsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - TableView DataSource
extension FavoritePostsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return postModel.favoritePosts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: detailedPostImageTableViewCell)
            if let cell = cell as? DetailedPostImageTableViewCell {
                let currentPost = postModel.favoritePosts[indexPath.section]
                cell.imageUrlInString = currentPost.imageUrlInString
                cell.isFavorite = currentPost.isFavorite
                cell.postTextLabel = currentPost.title
                cell.didFavoriteTap = { [weak self] in
                    let alert = UIAlertController(title: "Внимание", message: "Вы точно хотите удалить из избранного?", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Да, точно", style: UIAlertAction.Style.default, handler: { action in
                        let favoritesStorage: FavoritesStorage = FavoritesStorage.shared
                        
                        if favoritesStorage.isPostFavorite(post: currentPost.title) {
                            favoritesStorage.removeFavorite(favoritePost: currentPost.title)
                        } else {
                            favoritesStorage.addFavorite(favoritePost: currentPost.title)
                        }
                        cell.isFavorite.toggle()
                        if let favoritePost = self?.postModel.favoritePosts[indexPath.section] {
                        self?.postModel.favoritePost(for: favoritePost)
                        self?.tableView.reloadData()
                        }
                        }))
                    alert.addAction(UIAlertAction(title: "Нет", style: UIAlertAction.Style.cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
            return cell ?? UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: detailedPostTitleTableViewCell)
            if let cell = cell as? DetailedPostTitleTableViewCell {
                cell.titleText = postModel.favoritePosts[indexPath.section].title
                cell.titleDate = postModel.favoritePosts[indexPath.section].dateCreation
            }
            return cell ?? UITableViewCell()
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: detailedPostBodyShortedTableViewCell)
            if let cell = cell as? DetailedPostBodyShortedTableViewCell {
                cell.bodyText = postModel.favoritePosts[indexPath.section].content
            }
            return cell ?? UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let vc = DetailedPostViewController()
                vc.model = self.postModel.favoritePosts[indexPath.section]
                navigationController?.pushViewController(vc, animated: true)
    }
}

