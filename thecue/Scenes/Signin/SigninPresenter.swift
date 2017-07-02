//
//  SigninPresenter.swift
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

protocol SigninPresentationLogic {
    func presentLogin(response: Signin.LoginWithGoogle.Response)
}

class SigninPresenter: SigninPresentationLogic {
    weak var viewController: SigninDisplayLogic?

    // MARK: Login

    func presentLogin(response: Signin.LoginWithGoogle.Response) {
        let viewModel = Signin.LoginWithGoogle.ViewModel()
        viewController?.displayLogin(viewModel: viewModel)
    }
}
