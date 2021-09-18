//
//  AppCoordinator.swift
//  TurboDemo
//
//  Created by Dane Wilson on 9/16/21.
//

import SafariServices
import SwiftUI
import Turbo
import UIKit
import WebKit
import KeychainAccess
 
class AppCoordinator : NSObject {
    var rootViewController: UIViewController { navigationController }

    func start() {
        let keychain = Keychain(service: "Turbo-Credentials")
        keychain["access-token"] = nil
        if keychain["access-token"] != nil {
            visit(url: Endpoints.rootURL.absoluteURL)
        } else {
            let authURL = Endpoints.rootURL.appendingPathComponent("/users/sign_in")
            let properties = pathConfiguration.properties(for: authURL)
            visit(url: authURL, action: .advance, properties: properties)
        }
    }
    
    private let navigationController = UINavigationController()
    private lazy var pathConfiguration = PathConfiguration(sources: [
        .file(Bundle.main.url(forResource: "Turbo", withExtension: "json")!),
        .server(Endpoints.rootURL.appendingPathComponent("api/turbo.json"))
    ])
    
    private func visit(url: URL, action: VisitAction = .advance, properties: PathProperties = [:]) {
        let viewController: UIViewController
        // stops the page from double rendering on redirect
        let action: VisitAction = url ==
          session.topmostVisitable?.visitableURL ? .replace : action
        
        // Dismiss any modals when receiving a new navigation
        if navigationController.presentedViewController != nil {
            navigationController.dismiss(animated: true)
        }

        if properties["controller"] as? String == "numbers" {
            viewController = NumbersViewController()
        } else if url.path  == "/users/sign_in" {
            let view = LoginView(session: session, navigationController: navigationController)
            viewController = UIHostingController(rootView: view)
        } else {
            viewController = VisitableViewController(url: url)
        }
        
        if properties["presentation"] as? String == "modal" {
            print("TurboDemoApp: Present")
            navigationController.present(viewController, animated: true)
        } else if action == .advance && url.path == "/users/sign_in" {
            print("TurboDemoApp: Push - \(url) - \(Endpoints.rootURL.absoluteURL) - \(url.path)")
            navigationController.pushViewController(viewController, animated: true)
        } else {
            print("TurboDemoApp: Append")
            navigationController.viewControllers = Array(navigationController.viewControllers.dropLast()) + [viewController]
        }

        if let visitable = viewController as? Visitable {
            if properties["presentation"] as? String == "modal" {
                modalSession.visit(visitable)
            } else {
                session.visit(visitable)
            }
        }
    }
    
    private lazy var session = makeSession()
    private lazy var modalSession = makeSession()
    
    private func makeSession() -> Session {
        let configuration = WKWebViewConfiguration()
        let scriptMessageHandler = ScriptMessageHandler(delegate: self)
        configuration.userContentController.add(scriptMessageHandler, name: "nativeApp")
        
        let session = Session(webViewConfiguration: configuration)
        session.delegate = self
        session.webView.customUserAgent = "TurboApp (Turbo Native) / 1.0"
        session.pathConfiguration = pathConfiguration
        return session
    }
    
    private var nextActionButtonURL: URL?

    func addActionButton(url: URL, imageName: String) {
        let image = UIImage(systemName: imageName) // 🤩
        nextActionButtonURL = url
        let actionButton = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(self.visitActionButtonURL)
        )
        navigationController.visibleViewController?
            .navigationItem.rightBarButtonItem = actionButton
    }

    @objc private func visitActionButtonURL() {
        if let url = nextActionButtonURL {
            visit(url: url, properties: ["presentation": "modal"])
        }
        nextActionButtonURL = nil
    }
}

extension AppCoordinator: SessionDelegate {
    func session(_ session: Session, didProposeVisit proposal: VisitProposal) {
        print("Visting something....")
        visit(url: proposal.url, action: proposal.options.action, properties: proposal.properties)
    }
    
    func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, error: Error) {
        if error.isUnauthorized {
            // Render native sign-in flow
            print("TurboDemoApp - checking session")
            let view = LoginView(session: session, navigationController: navigationController)
            let controller = UIHostingController(rootView: view)
            navigationController.present(controller, animated: true)
        } else {
            // Handle actual errors
            guard let topViewController = navigationController.topViewController else { return }

            let swiftUIView = ErrorView(errorMessage: error.localizedDescription)
            let hostingController = UIHostingController(rootView: swiftUIView)

            topViewController.addChild(hostingController)
            hostingController.view.frame = topViewController.view.frame
            topViewController.view.addSubview(hostingController.view)
            hostingController.didMove(toParent: topViewController)
        }
    }
    
    func sessionDidLoadWebView(_ session: Session) {
        session.webView.navigationDelegate = self
    }
}

extension AppCoordinator: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard
            navigationAction.navigationType == .linkActivated,
            let url = navigationAction.request.url
        else {
            decisionHandler(.allow)
            return
        }

        let safariViewController = SFSafariViewController(url: url)
        navigationController.present(safariViewController, animated: true)
        decisionHandler(.cancel)
    }
}

extension AppCoordinator: ScriptMessageDelegate {}

extension Error {
    var isUnauthorized: Bool { httpStatusCode == 401 }

    private var httpStatusCode: Int? {
        guard
            let turboError = self as? TurboError,
            case let .http(statusCode) = turboError
        else { return nil }
        return statusCode
    }
}
