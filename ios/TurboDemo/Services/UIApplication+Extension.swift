//
//  UIApplication+Extension.swift
//  TurboDemo
//
//  Created by Dane Wilson on 9/17/21.
//
import UIKit

// Disables keyboard
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
