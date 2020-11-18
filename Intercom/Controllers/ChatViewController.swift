//
//  ChatViewController.swift
//  Intercom
//
//  Created by  Ronit D. on 11/14/20.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    private func validateAuth() {
        if Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
            print("Firebase user not found, successfully sent user to authentication page")
        }
    }

}
