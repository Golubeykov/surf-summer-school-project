//
//  DetailedPostViewController.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 06.08.2022.
//

import UIKit

class DetailedPostViewController: UIViewController, UIGestureRecognizerDelegate {
    //MARK: Constants
    private let backArrowImage: UIImage? = ImagesStorage.backArrow
    
    private let detailedPostImageTableViewCell: String = "\(DetailedPostImageTableViewCell.self)"
    private let detailedPostTitleTableViewCell: String = "\(DetailedPostTitleTableViewCell.self)"
    private let detailedPostBodyTableViewCell: String = "\(DetailedPostBodyTableViewCell.self)"
    
    private let numberOfRows = 3
    //MARK: - Views
    private let tableView = UITableView()
    //MARK: - Properties
    var model: PostModel?
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
}
//MARK: - Private methods
private extension DetailedPostViewController {
    func configureAppearance() {
        configureTableView()
    }
    
    func configureNavigationBar() {
        navigationItem.title = model?.title ?? ""
        let backButton = UIBarButtonItem(image: backArrowImage,
                                         style: .plain,
                                         target: navigationController,
                                         action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = ColorsStorage.black
        navigationController?.interactivePopGestureRecognizer?.delegate = self
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
        tableView.register(UINib(nibName: detailedPostBodyTableViewCell, bundle: .main), forCellReuseIdentifier: detailedPostBodyTableViewCell)
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
}
//MARK: - TableView DataSource
extension DetailedPostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: detailedPostImageTableViewCell)
            if let cell = cell as? DetailedPostImageTableViewCell {
                cell.imageUrlInString = model?.imageUrlInString ?? ""
            }
            return cell ?? UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: detailedPostTitleTableViewCell)
            if let cell = cell as? DetailedPostTitleTableViewCell {
                cell.titleText = model?.title ?? ""
                cell.titleDate = model?.dateCreation ?? ""
            }
            return cell ?? UITableViewCell()
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: detailedPostBodyTableViewCell)
            if let cell = cell as? DetailedPostBodyTableViewCell {
                cell.bodyText = model?.content ?? ""
            }
            return cell ?? UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    
}
