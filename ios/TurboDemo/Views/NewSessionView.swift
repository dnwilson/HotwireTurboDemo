//
//  NewSessionView.swift
//  TurboDemo
//
//  Created by Dane Wilson on 9/17/21.
//
import SwiftUI
import UIKit

struct NewSessionView: View {
    @ObservedObject var viewModel: SignInViewModel
    
    var body: some View {
        Form {
            TextField("name@example.com", text: $viewModel.email)
                .textContentType(.username)
                .keyboardType(.emailAddress)

            SecureField("password", text: $viewModel.password)
                .textContentType(.password)

            Button("Sign in", action: viewModel.signIn)
        }.autocapitalization(.none)
    }
}

struct NewSessionView_Preview: PreviewProvider {
    static var previews: some View {
        NewSessionView(viewModel: SignInViewModel())
    }
}
