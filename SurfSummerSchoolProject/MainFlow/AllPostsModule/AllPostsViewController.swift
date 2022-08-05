//
//  AllPostsViewController.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 04.08.2022.
//

import UIKit

class AllPostsViewController: UIViewController {
    
    private let postModel: AllPostsModel = .init()
    @IBOutlet private weak var allPostsCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearence()
        configureModel()
        postModel.getPosts()
    }
}
private extension AllPostsViewController {
    func configureAppearence() {
        allPostsCollectionView.register(UINib(nibName: "\(AllPostsCollectionViewCell.self)", bundle: .main), forCellWithReuseIdentifier: "\(AllPostsCollectionViewCell.self)")
        allPostsCollectionView.dataSource = self
    }
    func configureModel() {
        postModel.didPostsUpdated = { [weak self] in
            self?.allPostsCollectionView.reloadData()
        }
    }
    
    
}

//MARK: - UICollection

extension AllPostsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        postModel.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = allPostsCollectionView.dequeueReusableCell(withReuseIdentifier: "\(AllPostsCollectionViewCell.self)", for: indexPath)
        if let cell = cell as? AllPostsCollectionViewCell {
            cell.titleText = postModel.posts[indexPath.item].title
            cell.isFavorite = postModel.posts[indexPath.item].isFavorite
            cell.image = postModel.posts[indexPath.item].image
            
        }
        
        return cell
    }
    
    
}
