//
//  Numbers.swift
//  TurboDemo
//
//  Created by Dane Wilson on 9/16/21.
//
import SwiftUI

struct NumbersView: View {
    private let numbers = 1 ... 10

    var body: some View {
        List(numbers, id: \.self) { number in
            Text(String(number))
        }
    }
}

struct NumbersView_Preview: PreviewProvider {
    static var previews: some View {
        NumbersView()
    }
}
