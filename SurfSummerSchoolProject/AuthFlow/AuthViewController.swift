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
    
    //MARK: - Properties
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
    
    
    //MARK: - Methods
    @IBAction func loginButtonAction(_ sender: Any) {
        print("Test")
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullString = (textField.text ?? "") + string
        textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: range.length == 1)
        return false
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
