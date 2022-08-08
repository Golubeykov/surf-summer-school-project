//
//  DetailedPostViewController.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 06.08.2022.
//

import UIKit

class DetailedPostViewController: UIViewController, UIGestureRecognizerDelegate {
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
        let backButton = UIBarButtonItem(image: UIImage(named: "backArrow"),
                                         style: .plain,
                                         target: navigationController,
                                         action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = .black
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
        
        tableView.register(UINib(nibName: "\(DetailedPostImageTableViewCell.self)", bundle: .main), forCellReuseIdentifier: "\(DetailedPostImageTableViewCell.self)")
        tableView.register(UINib(nibName: "\(DetailedPostTitleTableViewCell.self)", bundle: .main), forCellReuseIdentifier: "\(DetailedPostTitleTableViewCell.self)")
        tableView.register(UINib(nibName: "\(DetailedPostBodyTableViewCell.self)", bundle: .main), forCellReuseIdentifier: "\(DetailedPostBodyTableViewCell.self)")
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
}
//MARK: - TableView DataSource
extension DetailedPostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(DetailedPostImageTableViewCell.self)")
            if let cell = cell as? DetailedPostImageTableViewCell {
                cell.imageUrlInString = model?.imageUrlInString ?? ""
            }
            return cell ?? UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(DetailedPostTitleTableViewCell.self)")
            if let cell = cell as? DetailedPostTitleTableViewCell {
                cell.titleText = model?.title ?? ""
                cell.titleDate = model?.dateCreation ?? ""
            }
            return cell ?? UITableViewCell()
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(DetailedPostBodyTableViewCell.self)")
            if let cell = cell as? DetailedPostBodyTableViewCell {
                cell.bodyText = model?.content ?? ""
            }
            return cell ?? UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    
}
