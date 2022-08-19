//
//  ProfileViewController.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 04.08.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    //MARK: - Constants
    private let profileMainInfoCell: String = "\(ProfileMainInfoCell.self)"
    private let contactsCell: String = "\(ContactsCell.self)"
    private let numberOfRows = 4
    private let mainInfoCellHeight: CGFloat = 160
    private let contactsCellHeight: CGFloat = 72
    
    //MARK: - Views
    @IBOutlet private weak var logoutButtonLabel: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Model
    private var profileModel: ProfileModel = ProfileInstance.shared.profileModel
    
    //MARK: - Actions
    @IBAction private func logoutButtonAction(_ sender: Any) {
        appendConfirmingAlertView(for: self, text: "Вы точно хотите выйти из приложения?", completion: { action in
            let buttonActivityIndicator = ButtonActivityIndicator(button: self.logoutButtonLabel, originalButtonText: "Выйти")
            buttonActivityIndicator.showButtonLoading()
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
                    case .failure(let error):
                        DispatchQueue.main.async {
                            buttonActivityIndicator.hideButtonLoading()
                            var textForSnackbar = "Не удалось выйти, попробуйте еще раз"
                            if let currentError = error as? PossibleErrors {
                                switch currentError {
                                case .noNetworkConnection:
                                    textForSnackbar = "Отсутствует интернет-соединение \nПопробуйте позже"
                                default:
                                    textForSnackbar = "Не удалось выйти, попробуйте еще раз"
                                }
                            }
                            
                            let model = SnackbarModel(text: textForSnackbar)
                            let snackbar = SnackbarView(model: model)
                            guard let `self` = self else { return }
                            snackbar.showSnackBar(on: self, with: model)
                        }
                    }
                }
        })
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
    private func configureNavigationBar() {
        navigationItem.title = "Профиль"
    }
    private func configureTableView() {
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
                cell.imageUrlInString = profileModel.avatar
                cell.profileQuoteLabel.text = profileModel.about
                cell.profileFirstNameLabel.text = profileModel.firstName
                cell.profileLastNameLabel.text = profileModel.lastName
            }
            return cell ?? UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: contactsCell)
            if let cell = cell as? ContactsCell {
                cell.contactTypeLabel.text = "Город"
                cell.contactDetailLabel.text = profileModel.city
            }
            return cell ?? UITableViewCell()
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: contactsCell)
            if let cell = cell as? ContactsCell {
                cell.contactTypeLabel.text = "Телефон"
                cell.contactDetailLabel.text = applyPhoneMask(phoneNumber: profileModel.phone, shouldRemoveLastDigit: false) 
            }
            return cell ?? UITableViewCell()
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: contactsCell)
            if let cell = cell as? ContactsCell {
                cell.contactTypeLabel.text = "Почта"
                cell.contactDetailLabel.text = profileModel.email
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

