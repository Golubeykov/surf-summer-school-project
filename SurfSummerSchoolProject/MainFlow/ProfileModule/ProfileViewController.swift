//
//  ProfileViewController.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 04.08.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: - Views
    @IBOutlet weak var logoutButtonLabel: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    let profileMainInfoCell: String = "\(ProfileMainInfoCell.self)"
    let contactsCell: String = "\(ContactsCell.self)"
    let numberOfRows = 4
    let mainInfoCellHeight: CGFloat = 160
    let contactsCellHeight: CGFloat = 72
    
    //MARK: - Actions
    @IBAction func logoutButtonAction(_ sender: Any) {
        print("testTap")
        LogoutService()
            .performLogoutRequestAndRemoveToken() { [weak self] result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        if let delegate = UIApplication.shared.delegate as? AppDelegate {
                            let authViewController = AuthViewController()
                            let navigationAuthViewController = UINavigationController(rootViewController: authViewController)
                            delegate.window?.rootViewController = navigationAuthViewController
                        }
                    }
                case .failure:
                    DispatchQueue.main.async {
                        let model = SnackbarModel(text: "Не получилось выйти")
                        let snackbar = SnackbarView(model: model)
                        guard let `self` = self else { return }
                        snackbar.showSnackBar(on: self, with: model)
                    }
                }
            }
    }
    
    //MARK: - Views lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    //MARK: - Methods
    func configureNavigationBar() {
        navigationItem.title = "Профиль"
    }
    func configureTableView() {
        tableView.register(UINib(nibName: profileMainInfoCell, bundle: .main), forCellReuseIdentifier: profileMainInfoCell)
        tableView.register(UINib(nibName: contactsCell, bundle: .main), forCellReuseIdentifier: contactsCell)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

//MARK: - UITableView DataSource
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRows
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: profileMainInfoCell)
            if let cell = cell as? ProfileMainInfoCell {
                cell.profileFirstNameLabel.text = "Иван"
                cell.profileLastNameLabel.text = "Иваныч"
            }
            return cell ?? UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: contactsCell)
            if let cell = cell as? ContactsCell {
                cell.contactTypeLabel.text = "Город"
                cell.contactDetailLabel.text = "Санкт-Петербург"
            }
            return cell ?? UITableViewCell()
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: contactsCell)
            if let cell = cell as? ContactsCell {
                cell.contactTypeLabel.text = "Телефон"
                cell.contactDetailLabel.text = "+7 (921) 856 21 45"
            }
            return cell ?? UITableViewCell()
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: contactsCell)
            if let cell = cell as? ContactsCell {
                cell.contactTypeLabel.text = "Почта"
                cell.contactDetailLabel.text = "HelloIvan@gmail.com"
            }
            return cell ?? UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return mainInfoCellHeight
        default:
            return contactsCellHeight
        }
    }
    
}
