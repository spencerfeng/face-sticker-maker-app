//
//  RoutingTransition.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 21/3/21.
//

import Foundation
import UIKit

protocol RoutingTransition: class {
    var viewController: UIViewController? { get set }
    
    func open(_ viewController: UIViewController)
    func close(_ viewController: UIViewController)
}
