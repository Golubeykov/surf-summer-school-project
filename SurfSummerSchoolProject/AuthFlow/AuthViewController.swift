//
//  AuthViewController.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 14.08.2022.
//

import UIKit

class AuthViewController: UIViewController {
    //MARK: - Views
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButtonLabel: UIButton!
    private let showHidePasswordButton = UIButton(type: .custom)
    
    @IBOutlet weak var passwordConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginBottomLine: UIView!
    @IBOutlet weak var passwordBottomLine: UIView!
    //MARK: - Properties
    //Маска номера телефона
    private let maxNumberCountInPhoneNumberField = 11
    private var regex: NSRegularExpression? {
        do {
            let regexExpression = try NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
            return regexExpression
        } catch {
            print(error)
            return nil
        }
    }
    //Activity indicator для кнопки Войти
    private var originalButtonText: String = "Войти"
    var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Methods
    @IBAction func loginButtonAction(_ sender: Any) {
        if loginTextField.text == "" {
            showEmptyLoginNotification()
        }
        if passwordTextField.text == "" {
            showEmptyPasswordNotification()
        }
        if !(loginTextField.text == "" && passwordTextField.text == "") {
            print("Test")
            showButtonLoading()
            guard let phoneNumber = loginTextField.text else { return }
            let phoneNumberClearedFromMask = clearPhoneNumberFromMask(phoneNumber: phoneNumber)
            guard let password = passwordTextField.text else { return }
            
            print(phoneNumberClearedFromMask)
            print(password)
            //let credentials = AuthRequestModel(phone: phoneNumberClearedFromMask, password: password)
            let credentials = AuthRequestModel(phone: "+79876543219", password: "qwerty")
            AuthService()
                .performLoginRequestAndSaveToken(credentials: credentials) { [weak self] result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                                let mainViewController = TabBarConfigurator().configure()
                                delegate.window?.rootViewController = mainViewController
                            }
                        }
                    case .failure:
                        print("failure")
                        self?.hideButtonLoading()
                    }
                }
        }
    }
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureApperance()
        enablePasswordToggle()
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.subcribeToNotificationCenter()
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) { super.viewWillDisappear(animated)
        unsubscribeFromNotificationCenter()
    }
}
//MARK: - Configure view
private extension AuthViewController {
    func configureApperance() {
        self.loginTextField.placeholder = "Логин"
        self.loginTextField.backgroundColor = ColorsStorage.lightBackgroundGray
        self.loginTextField.clipsToBounds = true
        self.loginTextField.layer.cornerRadius = 10
        self.loginTextField.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.loginTextField.delegate = self
        self.loginTextField.keyboardType = .numberPad
        self.loginTextField.setLeftPaddingPoints(18)
        
        self.passwordTextField.placeholder = "Пароль"
        self.passwordTextField.backgroundColor = ColorsStorage.lightBackgroundGray
        self.passwordTextField.clipsToBounds = true
        self.passwordTextField.layer.cornerRadius = 10
        self.passwordTextField.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.passwordTextField.delegate = self
        self.passwordTextField.setLeftPaddingPoints(18)
        //self.passwordTextField.setRightPaddingPoints(60)
    }
    func configureNavigationBar() {
        self.navigationItem.title = "Вход"
    }
}

//MARK: - Configuring UITextfield
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
//MARK: - Configuring password field
extension AuthViewController {
    
    func enablePasswordToggle(){
        showHidePasswordButton.setImage(ImagesStorage.passwordIsHiddenIcon, for: .normal)
        showHidePasswordButton.setImage(ImagesStorage.passwordIsShownIcon, for: .selected)
        showHidePasswordButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        showHidePasswordButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        passwordTextField.rightView = showHidePasswordButton
        passwordTextField.rightViewMode = .always
        showHidePasswordButton.alpha = 0.4
    }
    
    @objc func togglePasswordView(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
        showHidePasswordButton.isSelected.toggle()
    }
}

// MARK: - Handle entering a phone number
extension AuthViewController: UITextFieldDelegate {
    private func format(phoneNumber: String, shouldRemoveLastDigit: Bool) -> String {
        let range = NSString(string: phoneNumber).range(of: phoneNumber)
        guard let regex = regex else { return "\(phoneNumber)" }
        guard !(shouldRemoveLastDigit && phoneNumber.count <= 2 && phoneNumber.count >= 1) else { return "" }
        
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: [], range: range, withTemplate: "")
        
        if number.count > maxNumberCountInPhoneNumberField {
            let maxIndex = number.index(number.startIndex, offsetBy: maxNumberCountInPhoneNumberField)
            number = String(number[number.startIndex..<maxIndex])
        }
        if shouldRemoveLastDigit {
            let maxIndex = number.index(number.startIndex, offsetBy: number.count - 1)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        let maxIndex = number.index(number.startIndex, offsetBy: number.count)
        let regRange = number.startIndex..<maxIndex
        
        if number.count <= 4 {
            let pattern = "(\\d)(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2)", options: .regularExpression, range: regRange)
        } else if number.count <= 7 {
            let pattern = "(\\d)(\\d{3})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3", options: .regularExpression, range: regRange)
        } else if number.count < 10 {
            let pattern = "(\\d)(\\d{3})(\\d{3})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3-$4", options: .regularExpression, range: regRange)
        } else {
            let pattern = "(\\d)(\\d{3})(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3-$4-$5", options: .regularExpression, range: regRange)
        }
        return "+" + number
    }
    
    func clearPhoneNumberFromMask(phoneNumber: String) -> String {
        let phoneNumberClearedFromSymbols = phoneNumber.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
        return phoneNumberClearedFromSymbols
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullString = (textField.text ?? "") + string
        if textField == loginTextField {
            textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: range.length == 1)
            return false
        }
        return true
    }
}

//MARK: - Handle empty text fields
extension AuthViewController {
    func showEmptyLoginNotification() {
        loginBottomLine.backgroundColor = .red
        
        let loginEmptyNotification = UILabel(frame: CGRect(x: 0, y: 0, width: loginTextField.frame.width, height: 16))
        loginEmptyNotification.textAlignment = .left
        loginEmptyNotification.text = "Поле не может быть пустым"
        loginEmptyNotification.font = .systemFont(ofSize: 12)
        loginEmptyNotification.textColor = .red
        loginEmptyNotification.tag = 100
        self.view.addSubview(loginEmptyNotification)
        loginEmptyNotification.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginEmptyNotification.rightAnchor.constraint(equalTo: loginTextField.rightAnchor)
        ])
        NSLayoutConstraint(item: loginEmptyNotification, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 32.0).isActive = true
        NSLayoutConstraint(item: loginEmptyNotification, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: loginTextField, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 8.0).isActive = true
        passwordConstraint.constant = 40
        self.view.layoutIfNeeded()
    }
    func showEmptyPasswordNotification() {
        passwordBottomLine.backgroundColor = .red
        let passwordEmptyNotification = UILabel(frame: CGRect(x: 0, y: 0, width: loginTextField.frame.width, height: 16))
        passwordEmptyNotification.textAlignment = .left
        passwordEmptyNotification.text = "Поле не может быть пустым"
        passwordEmptyNotification.font = .systemFont(ofSize: 12)
        passwordEmptyNotification.textColor = .red
        passwordEmptyNotification.tag = 150
        self.view.addSubview(passwordEmptyNotification)
        passwordEmptyNotification.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordEmptyNotification.rightAnchor.constraint(equalTo: loginTextField.rightAnchor)
        ])
        NSLayoutConstraint(item: passwordEmptyNotification, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 32.0).isActive = true
        NSLayoutConstraint(item: passwordEmptyNotification, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: passwordTextField, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 8.0).isActive = true
        buttonConstraint.constant = 56
        self.view.layoutIfNeeded()
    }
    
    func dismissEmptyFieldsNotidication() {
        loginBottomLine.backgroundColor = ColorsStorage.lightTextGray
        passwordBottomLine.backgroundColor = ColorsStorage.lightTextGray
        if let emptyLoginNotificationLabel = self.view.viewWithTag(100) {
            emptyLoginNotificationLabel.removeFromSuperview()
        }
        if let emptyPasswordNotificationLabel = self.view.viewWithTag(150) {
            emptyPasswordNotificationLabel.removeFromSuperview()
        }
        passwordConstraint.constant = 17
        buttonConstraint.constant = 32
        self.view.layoutIfNeeded()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dismissEmptyFieldsNotidication()
    }
}

//MARK: - Adding activity indicator to Button after tap
extension AuthViewController {
    func showButtonLoading() {
        loginButtonLabel.setTitle("", for: .normal)
        
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        
        showSpinning()
    }
    
    func hideButtonLoading() {
        loginButtonLabel.setTitle(originalButtonText, for: .normal)
        activityIndicator.stopAnimating()
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .lightGray
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        loginButtonLabel.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        guard loginButtonLabel != nil else { return }
        let xCenterConstraint = NSLayoutConstraint(item: loginButtonLabel!, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        loginButtonLabel.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: loginButtonLabel!, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        loginButtonLabel.addConstraint(yCenterConstraint)
    }
}

//MARK: - Handle keyboard's show-up methods
extension AuthViewController {
    //Скрытие клавиатуры по тапу
    @objc func hideKeyboard() { self.scrollView?.endEditing(true)
    }
    func subcribeToNotificationCenter() {
        //Подписываемся на два уведомления: одно приходит при появлении клавиатуры. #selector(self.keyboardWasShown) - функция, которая выполняется после получения события.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func unsubscribeFromNotificationCenter() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //Функции, которые вызываются после появления / исчезновения клавиатуры (нужно чтобы клавиатура не залезала на поля ввода)
    @objc func keyboardWasShown(notification: Notification) {
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
        
    }
    //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем все Insets в ноль
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }
    
    
}
