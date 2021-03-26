//
//  InteractiveModalPresentationController.swift
//  castleGISspb
//
//  Created by Nikita Semenov on 21.03.2021.
//

import UIKit


enum ModalScaleState {
	case presentation
	case interaction
}

class InteractiveModalPresentationController: UIPresentationController {
	
	var presentedYOffset : CGFloat = 150

	private var direction: CGFloat = 0
	private var state: ModalScaleState = .interaction
	
	private lazy var dimmingView: UIView! = {
		guard let container = containerView else { return nil }
		
		let view = UIView(frame: container.bounds)
		view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
		view.addGestureRecognizer(
			UITapGestureRecognizer(target: self, action: #selector(didTap))
		)
		
		return view
	}()
	
	override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
		super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
	}

	@objc func didTap(_ tap: UITapGestureRecognizer) {
		presentedViewController.dismiss(animated: true)
	}
	
	override var frameOfPresentedViewInContainerView: CGRect {
		guard let container = containerView else { return .zero }
		
		return CGRect(x: 0, y: self.presentedYOffset, width: container.bounds.width, height: container.bounds.height - self.presentedYOffset)
	}
	
	override func presentationTransitionWillBegin() {
		guard let container = containerView,
			  let coordinator = presentingViewController.transitionCoordinator else { return }
		
		dimmingView.alpha = 0
		container.addSubview(dimmingView)
		dimmingView.addSubview(presentedViewController.view)
		
		coordinator.animate(alongsideTransition: { [weak self] context in
			guard let `self` = self else { return }
			
			self.dimmingView.alpha = 1
		}, completion: nil)
	}
	
	override func dismissalTransitionWillBegin() {
		guard let coordinator = presentingViewController.transitionCoordinator else { return }
		
		coordinator.animate(alongsideTransition: { [weak self] (context) -> Void in
			guard let `self` = self else { return }
			
			self.dimmingView.alpha = 0
		}, completion: nil)
	}
	
	override func dismissalTransitionDidEnd(_ completed: Bool) {
		if completed {
			dimmingView.removeFromSuperview()
		}
	}
}
