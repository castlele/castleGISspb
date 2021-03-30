//
//  SceneViewController.swift
//  castleGISspb
//
//  Created by Nikita Semenov on 10.03.2021.
//

import UIKit
import ArcGIS

// MARK:- Properties
final class SceneViewController: UIViewController {
	
	let DISTRICTS_REGIONS_KEY = "districtRegion"
	let DISTRICTS_CENTERS_KEY = "districtPoint"
	
	
	var mapViewController : MapViewController!
	
	var sceneView: AGSSceneView = {
		SceneView().scene
	}()
	
	lazy private var basemapPickerButton : ButtonView = {
		let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
		let button = ButtonView(bgColor: ColorPicker.getMainColor(), tintColor: ColorPicker.getSubAccentColor(), image: "square.stack.3d.down.forward.fill", imageConfiguration: imageConfig)
		button.layer.cornerRadius = Measurements.getCornerRadius()
		
		return button
	}()
	
	// MARK:- viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
		setupViews()
		
		placeSubViews()
		
		setConstraints()
    }

	private func setupViews() {
		setupSceneView()
		setupButtonsTargets()
	}
	
	private func setupSceneView() {
		view = sceneView
	}
	
	private func setupButtonsTargets() {
		basemapPickerButton.addTarget(self, action: #selector(presentBasemapPickerVC), for: .touchUpInside)
	}
	
	@objc private func presentBasemapPickerVC() {
		let basemapPickerViewController = mapViewController.basemapPickerViewController!
		
		let showCaseHeight = ShowcaseView().totalHeight * 10
		let paddings = Measurements.getPadding() * 10
		let buttonHeight = Measurements.getStandardButtonHeight()
		let offset = view.frame.height - showCaseHeight - paddings - buttonHeight
		
		let transitionDelegate = InteractiveTransitionDelegate(from: self, to: basemapPickerViewController, withOffset: offset)
		basemapPickerViewController.modalPresentationStyle = .custom
		basemapPickerViewController.transitioningDelegate = transitionDelegate
		
		present(basemapPickerViewController, animated: true)
	}
	
	private func placeSubViews() {
		view.addSubviews(
			basemapPickerButton
		)
	}
	
	private func setConstraints() {
		let margins = view.layoutMarginsGuide
		
		NSLayoutConstraint.activate([
			basemapPickerButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 15),
			basemapPickerButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
			basemapPickerButton.widthAnchor.constraint(equalToConstant: Measurements.getStandardButtonSize() - 13),
			basemapPickerButton.heightAnchor.constraint(equalToConstant: Measurements.getStandardButtonSize() - 13)
		])
	}
}
