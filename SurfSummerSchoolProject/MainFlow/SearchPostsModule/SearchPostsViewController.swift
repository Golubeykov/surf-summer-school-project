//
//  SearchPostsViewController.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 07.08.2022.
//

import UIKit

class SearchPostsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK: - Constants
    private enum ConstantConstraints {
        static let collectionViewPadding: CGFloat = 16
        static let hSpaceBetweenItems: CGFloat = 7
        static let vSpaceBetweenItems: CGFloat = 8
    }
    private enum ConstantImages {
        static let backArrow: UIImage? = ImagesStorage.backArrow
        static let searchLens: UIImage? = ImagesStorage.searchLens
        static let sadSmile: UIImage? = ImagesStorage.sadSmile
    }
    private let cellProportion: Double = 246/168
    
    //MARK: - Views
    @IBOutlet private weak var searchUserNotificationImage: UIImageView!
    @IBOutlet private weak var searchUserNotificationText: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    private var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 303, height: 32))
    
    //MARK: - Properties
    var posts = AllPostsModel.shared.filteredPosts(searchText: "")
    
    //MARK: - Methods
    func configureApperance() {
        searchUserNotificationText.font = .systemFont(ofSize: 14, weight: .light)
        searchUserNotificationImage.image = ConstantImages.searchLens
        searchUserNotificationText.text = "Введите ваш запрос"
        searchBar.delegate = self
        collectionView.register(UINib(nibName: "\(AllPostsCollectionViewCell.self)", bundle: .main), forCellWithReuseIdentifier: "\(AllPostsCollectionViewCell.self)")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 10, left: 16, bottom: 10, right: 16)
    }
    
    func configureNavigationBar() {
        let backButton = UIBarButtonItem(image: ConstantImages.backArrow,
                                         style: .plain,
                                         target: navigationController,
                                         action: #selector(UINavigationController.popViewController(animated:)))
        let searchBarItem = UIBarButtonItem(customView: searchBar)
        navigationItem.rightBarButtonItem = searchBarItem
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = ColorsStorage.black
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureApperance()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
    }
}
//MARK: - Search delegate

extension SearchPostsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchBar.resignFirstResponder()
        if !searchText.isEmpty {
            posts = AllPostsModel.shared.filteredPosts(searchText: searchBar.text ?? "")
            searchUserNotificationImage.image = UIImage()
            searchUserNotificationText.text = ""
            if posts.isEmpty {
                searchUserNotificationImage.image = ConstantImages.sadSmile
                searchUserNotificationText.text = "По этому запросу нет результатов, попробуйте другой запрос"
                collectionView.reloadData()
            } else {
                collectionView.reloadData()
            }
        } else {
            posts = []
            collectionView.reloadData()
            searchUserNotificationImage.image = ConstantImages.searchLens
            searchUserNotificationText.text = "Введите ваш запрос"
        }
    }
}

extension SearchPostsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(AllPostsCollectionViewCell.self)", for: indexPath)
        if let cell = cell as? AllPostsCollectionViewCell {
            cell.titleText = posts[indexPath.item].title
            cell.isFavorite = posts[indexPath.item].isFavorite
            cell.imageUrlInString = posts[indexPath.item].imageUrlInString
            cell.didFavoriteTap = { [weak self] in
                self?.posts[indexPath.item].isFavorite.toggle()
                guard let post = self?.posts[indexPath.item] else { return }
                AllPostsModel.shared.favoritePost(for: post)
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (view.frame.width - ConstantConstraints.collectionViewPadding * 2 - ConstantConstraints.hSpaceBetweenItems) / 2
        return CGSize(width: itemWidth, height: itemWidth * cellProportion)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ConstantConstraints.vSpaceBetweenItems
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return ConstantConstraints.hSpaceBetweenItems
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailedPostViewController()
        vc.model = posts[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
}

