//
//  ProfileViewController.swift
//  Intercom
//
//  Created by  Ronit D. on 11/14/20.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var mainView: UITableView!
    
    // Preparing the table view cells
    let cellData = ["Log Out"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assigning the delegate and datasource to the controller
        mainView.delegate = self
        mainView.dataSource = self
        
        // Register the table view cells to the table view
        mainView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // Log out existing user
    private func logOutUser() {
        
        // Warn user of logging out
        let alert = UIAlertController(title: "Whoa there", message: "Are you sure you would like to log out?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes, Proceed", style: .destructive, handler: { [weak self] (action) in
            
            // Creating a "strong" reference on "self"
            guard let strongSelf = self else { return }
            
            // Ping Firebase's authentication to logout user
            do {
                try Auth.auth().signOut()
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav, animated: true, completion: nil)
            }
            catch {
                print("Failed to log out user")
            }
        }))
        alert.addAction(UIAlertAction(title: "No, Go Back", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }

}

// Table View
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    
    // Control the number of sections present
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellData.count
    }
    
    // Control the data of each table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cellData[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    // Control the action when pressing a table view cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        logOutUser()
    }
}
