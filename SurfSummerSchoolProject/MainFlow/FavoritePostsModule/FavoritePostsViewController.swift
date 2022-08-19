//
//  FavoritePostsViewController.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 04.08.2022.
//

import UIKit

class FavoritePostsViewController: UIViewController {
    //MARK: Constants
    private enum ConstantImages {
        static let searchBar: UIImage? = ImagesStorage.searchBar
        static let sadSmile: UIImage? = ImagesStorage.sadSmile
    }
    
    private let detailedPostImageTableViewCell: String = "\(DetailedPostImageTableViewCell.self)"
    private let detailedPostTitleTableViewCell: String = "\(DetailedPostTitleTableViewCell.self)"
    private let detailedPostBodyShortedTableViewCell: String = "\(DetailedPostBodyShortedTableViewCell.self)"
    private let alertViewText: String = "Вы точно хотите удалить из избранного?"
    private let numberOfRows = 3
    //MARK: - Views
    private let tableView = UITableView()
    @IBOutlet private weak var emptyFavoritesNotificationImage: UIImageView!
    @IBOutlet private weak var emptyFavoritesNotificationText: UILabel!
    
    //MARK: - Singleton instances
    private let postModel: AllPostsModel = AllPostsModel.shared
    
    //MARK: - Public properties
    static var favoriteTapStatus: Bool = false
    static var successLoadingPostsAfterZeroScreen: Bool = false //флаг для edge-кейса, когда мы зашли в приложение без сети, получили zero-скрины на главном и избранном, обновили данные на главном и хотим, чтобы на соседней вкладке с избранным данные тоже обновились. 
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
        if !(postModel.favoritePosts.isEmpty) && FavoritePostsViewController.successLoadingPostsAfterZeroScreen {
            nonEmptyFavoritesNotification()
            tableView.reloadData()
        }
        if FavoritePostsViewController.favoriteTapStatus {
            tableView.reloadData()
            FavoritePostsViewController.favoriteTapStatus = false
            postModel.favoritePosts.isEmpty ? emptyFavoritesNotification() : nonEmptyFavoritesNotification()
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
        let searchButton = UIBarButtonItem(image: ConstantImages.searchBar,
                                           style: .plain,
                                           target: self,
                                           action: #selector(goToSearchVC(sender:)))
        navigationItem.rightBarButtonItem = searchButton
        navigationItem.rightBarButtonItem?.tintColor = ColorsStorage.black
    }
    func configureModel() {
        emptyFavoritesNotification()
        postModel.didPostsUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.tableView.reloadData()
                self.postModel.favoritePosts.isEmpty ? self.emptyFavoritesNotification() : self.nonEmptyFavoritesNotification()
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
    func emptyFavoritesNotification() {
        view.bringSubviewToFront(emptyFavoritesNotificationImage)
        view.bringSubviewToFront(emptyFavoritesNotificationText)
        emptyFavoritesNotificationImage.image = ConstantImages.sadSmile
        emptyFavoritesNotificationText.font = .systemFont(ofSize: 14, weight: .light)
        emptyFavoritesNotificationText.text = "В избранном пусто"
    }
    func nonEmptyFavoritesNotification() {
        emptyFavoritesNotificationImage.image = UIImage()
        emptyFavoritesNotificationText.text = ""
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
                    guard let `self` = self else { return }
                    appendConfirmingAlertView(for: self, text: self.alertViewText) { action in
                        let favoritesStorage: FavoritesStorage = FavoritesStorage.shared
                        
                        if favoritesStorage.isPostFavorite(post: currentPost.title) {
                            favoritesStorage.removeFavorite(favoritePost: currentPost.title)
                        } else {
                            favoritesStorage.addFavorite(favoritePost: currentPost.title)
                        }
                        cell.isFavorite.toggle()
                        let favoritePost = self.postModel.favoritePosts[indexPath.section]
                        self.postModel.favoritePost(for: favoritePost)
                        self.tableView.reloadData()
                        self.postModel.favoritePosts.isEmpty ? self.emptyFavoritesNotification() : self.nonEmptyFavoritesNotification()
                    }
                }
            }
            return cell ?? UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: detailedPostTitleTableViewCell)
            if let cell = cell as? DetailedPostTitleTableViewCell {
                cell.titlePostText.text = postModel.favoritePosts[indexPath.section].title
                cell.titlePostDate.text = postModel.favoritePosts[indexPath.section].dateCreation
            }
            return cell ?? UITableViewCell()
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: detailedPostBodyShortedTableViewCell)
            if let cell = cell as? DetailedPostBodyShortedTableViewCell {
                cell.bodyTextShorted.text = postModel.favoritePosts[indexPath.section].content
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

