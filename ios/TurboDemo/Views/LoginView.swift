//
//  LoginView.swift
//  TurboDemo
//
//  Created by Dane Wilson on 9/17/21.
//

import SwiftUI
import Turbo

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @StateObject var authentication = Authentication()
    var session: Session
    var navigationController: UINavigationController

    var body: some View {
        VStack(alignment: .center) {
            Text("TurboDemo").font(.largeTitle)
            TextField("Email Address", text: $viewModel.credentials.email)
                .keyboardType(.emailAddress)
            SecureField("Password", text: $viewModel.credentials.password)
            
            if (viewModel.showProgressView) {
                ProgressView()
            }
            
            Button("Login") {
                viewModel.login { success in
                    let visitable = VisitableViewController(url: Endpoints.rootURL)
                    session.visit(visitable, options: VisitOptions(action: .replace))
                    session.reload()
                    let viewControllers = Array(navigationController.viewControllers.dropLast()) + [visitable]
                    navigationController.setViewControllers(viewControllers, animated: false)
                    authentication.updateValidation(success: success)
                }
            }
            .disabled(viewModel.loginDisabled)
            .padding(16)
        }
        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
        .alert(item: $viewModel.error) { error in
            Alert(title: Text("Invalid Login"), message: Text(error.localizedDescription))
        }
    }
}

struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        LoginView(session: Session(), navigationController: UINavigationController())
    }
}
