//
//  NumbersViewController.swift
//  TurboDemo
//
//  Created by Dane Wilson on 9/16/21.
//

import SwiftUI
import UIKit

class NumbersViewController: UIHostingController<NumbersView> {
    init() {
        super.init(rootView: NumbersView())
    }
    
    @available(*, unavailable)
    @objc dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
