//
//  SigninRouter.swift
//  thecue
//
//  Created by Benjamin Grima on 01/07/2017.
//  Copyright (c) 2017 Usabilla. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol SigninRoutingLogic {
    func routeToLobby()
}

protocol SigninDataPassing {
    var dataStore: SigninDataStore? { get }
}

class SigninRouter: NSObject, SigninRoutingLogic, SigninDataPassing {
    weak var viewController: SigninViewController?
    var dataStore: SigninDataStore?

    // MARK: Routing

    func routeToLobby() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = "navigationControllerIdentifier"
        //swiftlint:disable force_cast
        let destinationNC = storyboard.instantiateViewController(withIdentifier: identifier) as! UINavigationController
        let destinationVC = destinationNC.topViewController as! LobbyViewController
        //swiftlint:enable force_cast

        var destinationDS = destinationVC.router!.dataStore!
        passDataToLobby(source: dataStore!, destination: &destinationDS)
        navigateToSomewhere(source: viewController!, destination: destinationNC)
    }

    // MARK: Navigation

    func navigateToSomewhere(source: SigninViewController, destination: UINavigationController) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }

        guard let rootViewController = window.rootViewController else {
            return
        }

        destination.view.frame = rootViewController.view.frame
        destination.view.layoutIfNeeded()

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = destination
        })
    }

    // MARK: Passing data

    func passDataToLobby(source: SigninDataStore, destination: inout LobbyDataStore) {
    }
}
