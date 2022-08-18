//
//  AllPostsViewController.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 04.08.2022.
//

import UIKit

class AllPostsViewController: UIViewController {
    //MARK: - Constants
    private enum ConstantConstraints {
        static let collectionViewPadding: CGFloat = 16
        static let hSpaceBetweenItems: CGFloat = 7
        static let vSpaceBetweenItems: CGFloat = 8
    }
    private enum ConstantImages {
        static let searchBar: UIImage? = ImagesStorage.searchBar
    }
    private let fetchPostsErrorVC = PostsLoadErrorViewController()
    private let cellProportion: Double = 246/168
    private let allPostsCollectionViewCell: String = "\(AllPostsCollectionViewCell.self)"
    
    //MARK: - Private properties
    private let postModel = AllPostsModel.shared
    
    //MARK: - Views
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var allPostsCollectionView: UICollectionView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        postModel.loadPosts()
        configureAppearence()
        configureModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allPostsCollectionView.reloadData()
        appendStateViewController {
            self.postModel.loadPosts()
            self.fetchPostsErrorVC.view.alpha = 0
            self.activityIndicatorView.isHidden = false
        }
        if postModel.currentState == .error {
            fetchPostsErrorVC.view.alpha = 1
            configureModel()
        }
        configureNavigationBar()
    }
}

//MARK: - Private methods
private extension AllPostsViewController {
    func configureAppearence() {
        allPostsCollectionView.register(UINib(nibName: "\(AllPostsCollectionViewCell.self)", bundle: .main), forCellWithReuseIdentifier: "\(AllPostsCollectionViewCell.self)")
        allPostsCollectionView.dataSource = self
        allPostsCollectionView.delegate = self
        allPostsCollectionView.contentInset = .init(top: 10, left: 16, bottom: 10, right: 16)
    }
    func configureNavigationBar() {
        navigationItem.title = "Главная"
        let searchButton = UIBarButtonItem(image: ConstantImages.searchBar,
                                         style: .plain,
                                         target: self,
                                           action: #selector(goToSearchVC(sender:)))
        navigationItem.rightBarButtonItem = searchButton
        navigationItem.rightBarButtonItem?.tintColor = ColorsStorage.black
    }
    func configureModel() {
        postModel.didPostsFetchErrorHappened = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicatorView.isHidden = true
                self?.fetchPostsErrorVC.view.alpha = 1
             }
        }
        postModel.didPostsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicatorView.isHidden = true
                self?.allPostsCollectionView.reloadData()
             }
        }
    }
    @objc func goToSearchVC(sender: UIBarButtonItem) {
        let vc = SearchPostsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func appendStateViewController(refreshButtonAction: @escaping ()->Void) {
        fetchPostsErrorVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(fetchPostsErrorVC)
        self.view.addSubview(fetchPostsErrorVC.view)
        fetchPostsErrorVC.didMove(toParent: self)
        
        fetchPostsErrorVC.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        fetchPostsErrorVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        fetchPostsErrorVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        fetchPostsErrorVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        fetchPostsErrorVC.view.alpha = 0
        fetchPostsErrorVC.refreshButtonAction = refreshButtonAction
    }
    
}

//MARK: - UICollection

extension AllPostsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postModel.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = allPostsCollectionView.dequeueReusableCell(withReuseIdentifier: allPostsCollectionViewCell, for: indexPath)
        if let cell = cell as? AllPostsCollectionViewCell {
            self.activityIndicatorView.isHidden = true
            cell.titleText = postModel.posts[indexPath.item].title
            cell.isFavorite = postModel.posts[indexPath.item].isFavorite
            cell.imageUrlInString = postModel.posts[indexPath.item].imageUrlInString
            cell.didFavoriteTap = { [weak self] in
                self?.postModel.posts[indexPath.item].isFavorite.toggle()
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
        vc.model = self.postModel.posts[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
}
