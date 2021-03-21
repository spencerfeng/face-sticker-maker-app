//
//  Router.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 22/3/21.
//

import UIKit

protocol Closable: class {
    func close()
}

protocol RouterProtocol: class {
    associatedtype V: UIViewController
    var viewController: V? { get }
    
    func open(_ viewController: UIViewController, transition: RoutingTransition)
}

class Router<U>: RouterProtocol, Closable where U: UIViewController {
    typealias V = U
    
    weak var viewController: V?
    var openTransition: RoutingTransition?
    
    func open(_ viewController: UIViewController, transition: RoutingTransition) {
        transition.viewController = self.viewController
        transition.open(viewController)
    }
    
    func close() {
        guard let openTransition = openTransition else {
            assertionFailure("You should specify an open transition in order to close a module.")
            return
        }
        guard let viewController = viewController else {
            assertionFailure("Nothing to close.")
            return
        }
        openTransition.close(viewController)
    }
}
