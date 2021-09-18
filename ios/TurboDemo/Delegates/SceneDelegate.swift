//
//  SceneDelegate.swift
//  TurboDemo
//
//  Created by Dane Wilson on 9/16/21.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let coordinator = AppCoordinator()
    @StateObject var authentication = Authentication()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        makeAndAssignWindow(in: windowScene)
        coordinator.start()
    }
    
    private func makeAndAssignWindow(in windowScene: UIWindowScene) {
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = coordinator.rootViewController
        window.makeKeyAndVisible()
        self.window = window
    }
}
