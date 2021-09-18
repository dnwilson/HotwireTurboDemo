//
//  ScriptMessageHandler.swift
//  TurboDemo
//
//  Created by Dane Wilson on 9/16/21.
//

import WebKit

protocol ScriptMessageDelegate: AnyObject {
    func addActionButton(url: URL, imageName: String)
}

class ScriptMessageHandler: NSObject, WKScriptMessageHandler {
    private weak var delegate: ScriptMessageDelegate?

   init(delegate: ScriptMessageDelegate) {
       self.delegate = delegate
   }

   func userContentController(
       _ userContentController: WKUserContentController,
       didReceive message: WKScriptMessage
   ) {
       guard
           let body = message.body as? [String: Any],
           let path = body["path"] as? String,
           let imageName = body["icon"] as? String
       else { return }

       let url = Endpoints.rootURL.appendingPathComponent(path)
       delegate?.addActionButton(url: url, imageName: imageName)
   }
}

struct Endpoints {
    static var rootURL = URL(string: "http://localhost:3000")!
}
