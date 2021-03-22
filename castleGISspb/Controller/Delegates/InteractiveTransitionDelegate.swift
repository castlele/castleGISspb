//
//  InteractiveTransitionDelegate.swift
//  castleGISspb
//
//  Created by Nikita Semenov on 21.03.2021.
//

import UIKit

class InteractiveTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
	
	var offset : CGFloat!
	
	init(from presented: UIViewController, to presenting: UIViewController, withOffset offset: CGFloat) {
		super.init()
		
		self.offset = offset
	}
	
	// MARK: - UIViewControllerTransitioningDelegate
	func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		let presentationController = InteractiveModalPresentationController(presentedViewController: presented, presenting: presenting)
		presentationController.presentedYOffset = offset
		return presentationController
	}
}
