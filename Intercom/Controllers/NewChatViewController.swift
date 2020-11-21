//
//  NewChatViewController.swift
//  Intercom
//
//  Created by  Ronit D. on 11/14/20.
//

import UIKit
import JGProgressHUD

class NewChatViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search for users..."
        return bar
    }()
    
    private let usersView: UITableView = {
        let view = UITableView()
        view.isHidden = true
        view.register(UITableViewCell.self, forCellReuseIdentifier: "user")
        return view
    }()
    
    private let noUsersLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Users Found"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        searchBar.becomeFirstResponder()
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}

// Search bar
extension NewChatViewController: UISearchBarDelegate {
    
    // Search button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
