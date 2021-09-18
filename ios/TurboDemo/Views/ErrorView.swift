//
//  ErrorView.swift
//  TurboDemo
//
//  Created by Dane Wilson on 9/16/21.
//

import SwiftUI

struct ErrorView: View {
    let errorMessage: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .scaledToFit()
                .foregroundColor(.accentColor)
                .frame(height: 40)
            Text("Error loading page")
                .font(.title)
            Text(errorMessage)
        }
    }
}


struct ErrorView_Preview: PreviewProvider {
    static var previews: some View {
        ErrorView(errorMessage: "Oops! Something went wrong.")
    }
}
