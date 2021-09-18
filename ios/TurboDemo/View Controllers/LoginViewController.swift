//
//  LoginViewController.swift
//  TurboDemo
//
//  Created by Dane Wilson on 9/17/21.
//

import SwiftUI
import UIKit

class LoginViewController: UIHostingController<NewSessionView> {
    init() {
        super.init(rootView: NewSessionView(viewModel: SignInViewModel()))
    }
    
    @available(*, unavailable)
    @objc dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
