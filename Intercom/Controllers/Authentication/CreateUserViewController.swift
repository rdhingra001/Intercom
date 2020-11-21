//
//  CreateUserViewController.swift
//  Intercom
//
//  Created by  Ronit D. on 11/14/20.
//

import UIKit
import Firebase
import JGProgressHUD

class CreateUserViewController: UIViewController {
    
    // Preparing our assets
    private let profilePicView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "person.circle")
        view.tintColor = .systemGray3
        view.contentMode = .scaleAspectFit
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedChangeProfilePic))
        gesture.numberOfTouchesRequired = 1
        view.addGestureRecognizer(gesture)
        view.isUserInteractionEnabled = true
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private let mainView: UIScrollView = {
        let view = UIScrollView()
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let firstNameField: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemTeal.cgColor
        field.attributedPlaceholder = NSAttributedString(string: "First Name",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemYellow])
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        return field
    }()
    
    private let lastNameField: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.systemTeal.cgColor
        field.attributedPlaceholder = NSAttributedString(string: "Last Name",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemYellow])
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        return field
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
    
    private let registerBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Register", for: .normal)
        btn.backgroundColor = .systemGreen
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return btn
    }()
    
    private let spinner = JGProgressHUD(style: .dark)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        view.backgroundColor = .link
        
        // Adding our subviews
        view.addSubview(mainView)
        mainView.addSubview(profilePicView)
        mainView.addSubview(firstNameField)
        mainView.addSubview(lastNameField)
        mainView.addSubview(emailField)
        mainView.addSubview(passwordField)
        mainView.addSubview(registerBtn)
        
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
        profilePicView.frame = CGRect(x: (mainView.width - size) / 2, y: 20, width: size, height: size)
        
        // Aligning the first name
        firstNameField.frame = CGRect(x: 30, y: profilePicView.bottom + 10, width: mainView.width - 60, height: 52)
        
        // Aligning the last name
        lastNameField.frame = CGRect(x: 30, y: firstNameField.bottom + 10, width: mainView.width - 60, height: 52)
        
        // Aligning the email
        emailField.frame = CGRect(x: 30, y: lastNameField.bottom + 10, width: mainView.width - 60, height: 52)
        
        // Aligning the password
        passwordField.frame = CGRect(x: 30, y: emailField.bottom + 10, width: mainView.width - 60, height: 52)
        
        // Aligning the button
        registerBtn.frame = CGRect(x: 30, y: passwordField.bottom + 10, width: mainView.width - 60, height: 52)
        
        // Giving the profile pic rounded corners
        profilePicView.layer.cornerRadius = profilePicView.width / 2
    
    }
    
    @objc private func registerButtonTapped() {
        
        // Hiding the keyboards
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        // Checking the fields
        guard let firstName = firstNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines), let lastName = lastNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines), let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines), let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertRegisterError()
            return
        }
        
        // Show the progress indicator
        spinner.show(in: view)
        
        // Check if email is in use
        DatabaseManager.shared.emailIsUsed(with: email) { [weak self] (exists) in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            guard !exists else {
                // User already exists
                strongSelf.alertRegisterError(message: "Looks like an existing user is already using that email.")
                return
            }
            // Firebase Authentication
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                guard result != nil, error == nil else {
                    if let err = error {
                        print(err.localizedDescription)
                        strongSelf.alertRegisterError(message: err.localizedDescription)
                    }
                    return
                }
                
                // Writing user data to database
                DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email))
                
                
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @objc private func tappedChangeProfilePic() {
        presentPhotoActions()
    }
    
    func alertRegisterError(message: String = "Please enter all information to create an Intercom account.") {
        let alert = UIAlertController(title: "Uh Oh", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

// Text field delegate
extension CreateUserViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            registerButtonTapped()
        }
        return true
    }
}

// Image picker
extension CreateUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActions() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Do you want to use an existing picture, or take one with your camera?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoLibrary()
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoLibrary() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profilePicView.image = selectedImage
        }
        else if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profilePicView.image = selectedImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
