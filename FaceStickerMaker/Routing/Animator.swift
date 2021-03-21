//
//  Animator.swift
//  FaceStickerMaker
//
//  Created by Spencer Feng on 21/3/21.
//

import UIKit

protocol Animator: UIViewControllerAnimatedTransitioning {
    var isPresenting: Bool { get set }
}
