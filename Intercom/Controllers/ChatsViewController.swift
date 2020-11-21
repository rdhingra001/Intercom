//
//  ChatViewController.swift
//  Intercom
//
//  Created by  Ronit D. on 11/14/20.
//

import UIKit
import Firebase
import JGProgressHUD

class ChatsViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let chatView: UITableView = {
        let tview = UITableView()
        tview.isHidden = true
        tview.register(UITableViewCell.self, forCellReuseIdentifier: "chatCell")
        return tview
    }()
    
    private let noConvsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Conversations!"
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creating our create chat bar button item
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(tappedComposeBtn))
        
        // Adding our elements to the view
        view.addSubview(chatView)
        view.addSubview(noConvsLabel)
        
        // Kick off some important tasks
        setupChatView()
        fetchConversations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Align the elements
        chatView.frame = view.bounds
    }
    
    // Check if there is a user logged in; if not, bring up login page
    private func validateAuth() {
        if Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
            print("Firebase user not found, successfully sent user to authentication page")
        }
    }
    
    // Setting up the chat table view
    private func setupChatView() {
        chatView.delegate = self
        chatView.dataSource = self
    }
    
    // Fetch user's conversations
    private func fetchConversations() {
        chatView.isHidden = false
    }
    
    // Send user to add chat controller
    @objc private func tappedComposeBtn() {
        let vc = NewChatViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    

}

// Table view
extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        cell.textLabel?.text = "Hello World"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatViewController()
        vc.title = "Rohil Mukherjee"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
