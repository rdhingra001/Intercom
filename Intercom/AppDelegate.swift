//
//  AppDelegate.swift
//  Intercom
//
//  Created by  Ronit D. on 11/14/20.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        // Setting up google sign in background processes
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

// Google Sign In
extension AppDelegate: GIDSignInDelegate {
    
    // Signing in the user with their Google account
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        // Making sure there aren't any errors during login
        guard error == nil else {
            if let error = error {
                print("Failed to use Google Sign in: \(error.localizedDescription)")
            }
            return
        }
        
       
        // Making sure the user metadata is not "nil"
        guard let email = user.profile.email,
              let firstName = user.profile.givenName,
              let lastName = user.profile.familyName else { return }
        
        // Check if a user with the same email already exists
        DatabaseManager.shared.emailIsUsed(with: email) { [weak self] (exists) in
            guard let strongSelf = self else { return }
            if !exists {
                // Insert to database
                print("Adding to database")
                let intercomUser = IntercomUser(firstName: firstName,
                                                lastName: lastName,
                                                emailAddress: email)
                
                DatabaseManager.shared.insertUser(with: intercomUser, completion: { done in
                    if done {
                        // Upload image
                        if user.profile.hasImage {
                            guard let url = user.profile.imageURL(withDimension: 200) else { return }
                            
                            // Decoding the image data from url
                            URLSession.shared.dataTask(with: url) { (data, _, _) in
                                guard let data = data else { return }
                                
                                // Kicking off the upload task
                                let fileName = intercomUser.profilePicFileName
                                
                                // Send the data and file name to be sent to Firebase Storage
                                StorageManager.shared.uploadProfilePic(with: data, fileName: fileName) { (result) in
                                    switch result {
                                    case .success(let downloadURL):
                                        UserDefaults.standard.set(downloadURL, forKey: "profilePicUrl")
                                        print(downloadURL)
                                    case .failure(let error):
                                        print("Failure received to completion handler: \(error.localizedDescription)")
                                    }
                                }
                            }.resume()
                            
                        }
                    
                    }
                })
            }
            else {
                print("user already exists")
            }
        }
        
        // Getting our login credentials
        guard let auth = user.authentication else {
            print("Missing authentication object off of designated Google user")
            return
        }
        let cred = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        
        // Kick off the authentication process to Firebase
        Auth.auth().signIn(with: cred) { (result, err) in
            
            // Making sure that the result is not "nil" and that there isn't an error
            guard result != nil, err == nil else {
                if err != nil {
                    print("Result object not found, or the error was \(err!.localizedDescription)")
                }
                return
            }
            
            print("Successfully signed in with Google!")
            
            // Send notification to the Login controller
            NotificationCenter.default.post(name: .didLoginNotification, object: nil)
        }
    }
    
    // What to do if user disconnects from session
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Google user was disconnected")
    }
    
    // Permitting access to open in custom SSO login pages
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
}
