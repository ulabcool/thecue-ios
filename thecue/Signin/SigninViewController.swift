//
//  SigninViewController.swift
//  thecue
//
//  Created by Benjamin Grima on 30/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import UIKit
import GoogleSignIn

class SigninViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet var signInBtn: GIDSignInButton?

    var currentUser: GIDGoogleUser?

    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor.lightGray
        iv.layer.cornerRadius = 50
        iv.layer.borderWidth = 4
        iv.layer.borderColor = UIColor.lightGray.cgColor
        return iv
    }()
    
    var activitIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.activityIndicatorViewStyle = .white
        return ai
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self

        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            
            signInBtn?.isHidden = true
            
            view.addSubview(imageView)
            let image = userImage()
            imageView.image = image
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            
            imageView.addSubview(activitIndicator)
            activitIndicator.translatesAutoresizingMaskIntoConstraints = false
            activitIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
            activitIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
            
            activitIndicator.startAnimating()
        }
        
        currentUser = GIDSignIn.sharedInstance().currentUser
        if currentUser == nil {
            GIDSignIn.sharedInstance().signInSilently()
        }
    }
    
    func userImage() -> UIImage {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let filename = documentsDirectory.appendingPathComponent("userImage.png")
        let data = try! NSData(contentsOf: filename, options: [])
        return UIImage(data: data as Data)!
    }
}

