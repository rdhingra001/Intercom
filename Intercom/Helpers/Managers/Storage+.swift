//
//  Storage+.swift
//  Intercom
//
//  Created by  Ronit D. on 11/20/20.
//

import Foundation
import FirebaseStorage


final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    /// This function takes in the image metadata and file name as parameters, and implements the Firebase Storage API to upload this on a remote Firebase server. This uploaded picture can be accessed via a refence link.
    public func uploadProfilePic(with data: Data,
                                 fileName: String,
                                 completion: @escaping UploadPictureCompletion) {
        
        storage.child("images/\(fileName)").putData(data, metadata: nil) { [weak self] (metadata, err) in
            guard let strongSelf = self else { return }
            guard err == nil else {
                print("Error: \(err?.localizedDescription)")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            strongSelf.storage.child("images/\(fileName)").downloadURL { (url, downloadErr) in
                guard url != nil, downloadErr == nil else {
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    print("Download URL could not be found, error: \(downloadErr!.localizedDescription)")
                    return
                }
                let urlString = url!.absoluteString
                print("Download URL retreived successfully: \(urlString)")
                completion(.success(urlString))
            }
        }
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadURL
    }
}
