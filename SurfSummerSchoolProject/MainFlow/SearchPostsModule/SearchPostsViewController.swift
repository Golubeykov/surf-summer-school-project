//
//  SearchPostsViewController.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 07.08.2022.
//

import UIKit

class SearchPostsViewController: UIViewController, UIGestureRecognizerDelegate {
    //MARK: - Views
    @IBOutlet private weak var searchUserNotificationImage: UIImageView!
    @IBOutlet private weak var searchUserNotificationText: UILabel!
    private var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 303, height: 32))
    
    //MARK: - Properties
    var notifyImage: UIImage? {
        didSet {
            searchUserNotificationImage.image = notifyImage
        }
    }
    var notifyText: String = "" {
        didSet {
            searchUserNotificationText.text = notifyText
        }
    }
    //MARK: - Methods
    func configureApperance() {
        searchUserNotificationText.font = .systemFont(ofSize: 14, weight: .light)
        notifyImage = UIImage(named: "searchLens")
        searchUserNotificationText.text = "Введите ваш запрос"
        searchBar.delegate = self
    }
    
    func configureNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage(named: "backArrow"),
                                         style: .plain,
                                         target: navigationController,
                                         action: #selector(UINavigationController.popViewController(animated:)))
        let searchBarItem = UIBarButtonItem(customView: searchBar)
        navigationItem.rightBarButtonItem = searchBarItem
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = .black
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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            print(searchText)
            
            notifyImage = UIImage(named: "sadSmile")
            searchUserNotificationText.text = "По этому запросу нет результатов, попробуйте другой запрос"
        } else {
            notifyImage = UIImage(named: "searchLens")
            searchUserNotificationText.text = "Введите ваш запрос"
        }
    }
}
