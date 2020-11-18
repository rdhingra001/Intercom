//
//  LoginViewController.swift
//  Intercom
//
//  Created by  Ronit D. on 11/14/20.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // Preparing our assets
    private let logoView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Logo")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let mainView: UIScrollView = {
        let view = UIScrollView()
        view.clipsToBounds = true
        return view
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemTeal.cgColor
        field.attributedPlaceholder = NSAttributedString(string: "Email",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemYellow])
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .done
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemTeal.cgColor
        field.attributedPlaceholder = NSAttributedString(string: "Password",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemYellow])
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = .systemGreen
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        view.backgroundColor = .link
        
        // Creating our Register bar button item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(tappedRegister))
        
        // Adding our subviews
        view.addSubview(mainView)
        mainView.addSubview(logoView)
        mainView.addSubview(emailField)
        mainView.addSubview(passwordField)
        mainView.addSubview(loginBtn)
        
        // Assigning the delegates to itself
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Aligning the scroll view to the entire screen
        mainView.frame = view.bounds
        
        // Aligning the logo
        let size = mainView.width / 3
        logoView.frame = CGRect(x: (mainView.width - size) / 2, y: 20, width: size, height: size)
        
        // Aligning the email
        emailField.frame = CGRect(x: 30, y: logoView.bottom + 20, width: mainView.width - 60, height: 52)
        
        // Aligning the password
        passwordField.frame = CGRect(x: 30, y: emailField.bottom + 10, width: mainView.width - 60, height: 52)
        
        // Aligning the button
        loginBtn.frame = CGRect(x: 30, y: passwordField.bottom + 10, width: mainView.width - 60, height: 52)
    
    }
    
    @objc func loginButtonTapped() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        guard let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines), let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
        
        // Firebase Authentication
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard let strongSelf = self else { return }
            guard result != nil else {
                print("Failed to login in user with email: \(email)")
                return
            }
            let user = result!.user
            print("Logged in user: \(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Uh Oh", message: "Please enter all information to authenticate.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func tappedRegister() {
        let vc = CreateUserViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            loginButtonTapped()
        }
        return true
    }
}
