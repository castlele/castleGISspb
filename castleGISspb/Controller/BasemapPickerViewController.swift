//
//  BasemapSettingsViewController.swift
//  castleGISspb
//
//  Created by Nikita Semenov on 11.03.2021.
//

import UIKit
import ArcGIS

final class BasemapPickerViewController: UIViewController {
	
	private let geoViewOptions = ["2D", "3D"]
	static let basemapsForMapView : [String: AGSBasemap] = [
		"Topographic" : .topographicVector(),
		"Imagery" : .imageryWithLabelsVector(),
		"Navigation" : .navigationVector(),
		"Streets" : .streetsVector()
	]
	static let basemapsForSceneView : [String: AGSBasemap] = [
		"Topographic" : .topographic(),
		"Imagery" : .imagery(),
		"National Geographic" : .nationalGeographic(),
		"Streets" : .streets()
	]
	
	static var selectedBasemapForMapView : AGSBasemap = .topographicVector()
	static var selectedBasemapForSceneView : AGSBasemap = .topographic()
	
	private let basemapButtonsForMapView : [UIButton] = {
		let namesOfImages = ["topographic", "streets", "navigation", "imagery"]
		var buttons = [UIButton]()
		
		for name in namesOfImages {
			let image = UIImage(named: name)!
			let button = UIButton()
			button.setImage(image, for: .normal)
			button.layer.masksToBounds = true
			buttons.append(button)
		}
		
		return buttons
	}()
	
	private let basemapButtonsForSceneView : [UIButton] = {
		let namesOfImages = ["topographic", "streets", "nationalGeographic", "imagery"]
		var buttons = [UIButton]()
		
		for name in namesOfImages {
			let image = UIImage(named: name)!
			let button = UIButton()
			button.setImage(image, for: .normal)
			button.layer.masksToBounds = true
			buttons.append(button)
		}
		
		return buttons
	}()
	
	private var basemapNames : [UILabel] = []
	
	var mapViewController : MapViewController!
	
	private var navigationBarDivider: DividerView!
	private var geoViewSegmentedControllPicker : UISegmentedControl!
	
	private var showCaseOfBasemapsForMapView : ShowcaseView!
	private var showCaseOfBasemapsForSceneView : ShowcaseView!
	
	let dismissButton : ButtonView = {
		let font = UIFont.boldSystemFont(ofSize: 20)
		let button = ButtonView(bgColor: nil, titleColor: ColorPicker.getSubAccentColor(), font: font, text: "Done", isShadow: false)
		
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
		view.backgroundColor = ColorPicker.getMainColor()
		view.layer.cornerRadius = Measurements.getCornerRaduis()
		setDismissGesture()
		
		setupDividerView()
		setupGeoViewSegmentedControlPicker()
		setupShowCaseOfBasemapsForMapView()
		setupShowCaseOfBasemapsForSceneView()
		
		setupButtonsTargets()
		
		setDelegate()
	}
	
	private func setDismissGesture() {
		let gesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissBasemapPickerAndApplyChanges))
		gesture.direction = .down
		view.addGestureRecognizer(gesture)
	}
	
	private func setupDividerView() {
		navigationBarDivider = DividerView(with: ColorPicker.getAccentColor())
	}
	
	private func setupGeoViewSegmentedControlPicker() {
		geoViewSegmentedControllPicker = UISegmentedControl(items: geoViewOptions)
		geoViewSegmentedControllPicker.translatesAutoresizingMaskIntoConstraints = false
		geoViewSegmentedControllPicker.selectedSegmentIndex = 0
		
		customizeGeoViewSegmentedControlPicker()
	}
	
	private func customizeGeoViewSegmentedControlPicker() {
		let textAttributes = [NSAttributedString.Key.foregroundColor: ColorPicker.getStandardTextColor()]
		
		geoViewSegmentedControllPicker.setTitleTextAttributes(textAttributes, for: .normal)
		geoViewSegmentedControllPicker.backgroundColor = ColorPicker.getSubMainColor()
		geoViewSegmentedControllPicker.selectedSegmentTintColor = ColorPicker.getSubAccentColor()
		geoViewSegmentedControllPicker.layer.cornerRadius = Measurements.getCornerRaduis()
		geoViewSegmentedControllPicker.layer.borderColor = ColorPicker.getAccentColor().cgColor
		
		geoViewSegmentedControllPicker.layer.borderWidth = navigationBarDivider.DEFAULT_HEIGHT
	}
	
	private func setupShowCaseOfBasemapsForMapView() {
		let basemaps = ["Topographic", "Streets", "Navigation", "Imagery"]
		setLabels(namesOfBasemaps: basemaps)
		showCaseOfBasemapsForMapView = ShowcaseView(views: basemapButtonsForMapView, labels: basemapNames)
		
		let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToLeftShowCase))
		gesture.direction = .left
		showCaseOfBasemapsForMapView.addGestureRecognizer(gesture)
	}
	
	@objc private func swipeToLeftShowCase(_ sender: UIButton) {
		geoViewSegmentedControllPicker.selectedSegmentIndex = 1
		changeGeoViewShowCase(geoViewSegmentedControllPicker)
	}
	
	private func setupShowCaseOfBasemapsForSceneView() {
		let basemaps = ["Topographic", "Streets", "National Geographic", "Imagery"]
		setLabels(namesOfBasemaps: basemaps)
		showCaseOfBasemapsForSceneView = ShowcaseView(views: basemapButtonsForSceneView, labels: basemapNames)
		
		let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToRightShowCase))
		gesture.direction = .right
		showCaseOfBasemapsForSceneView.addGestureRecognizer(gesture)
	}
	
	@objc private func swipeToRightShowCase(_ sender: UIButton) {
		geoViewSegmentedControllPicker.selectedSegmentIndex = 0
		changeGeoViewShowCase(geoViewSegmentedControllPicker)
	}
	
	private func setLabels(namesOfBasemaps names: [String]) {
		basemapNames.removeAll()
		
		for name in names {
			let label = UILabel()
			label.text = name
			basemapNames.append(label)
		}
	}
	
	private func setupButtonsTargets() {
		dismissButton.addTarget(self, action: #selector(dismissBasemapPickerAndApplyChanges), for: .touchUpInside)
		geoViewSegmentedControllPicker.addTarget(self, action: #selector(changeGeoViewShowCase), for: .valueChanged)
	}
	
	@objc private func dismissBasemapPickerAndApplyChanges(_ sender: UIButton) {
		applyBasemap()
		dismiss(animated: true, completion: changeGeoView)
	}
	
	private func changeGeoView() {
		if geoViewSegmentedControllPicker.selectedSegmentIndex == 1 {
			if mapViewController.navigationController?.topViewController != mapViewController.sceneViewController {
				mapViewController.navigationController?.pushViewController(mapViewController.sceneViewController, animated: false)
			}
		} else {
			mapViewController.navigationController?.popToRootViewController(animated: false)
		}
	}
	
	@objc private func changeGeoViewShowCase(_ sender: UISegmentedControl) {
		ShowcaseView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
			if sender.selectedSegmentIndex == 1 {
				self.showCaseOfBasemapsForMapView.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0)
				self.showCaseOfBasemapsForSceneView.transform = CGAffineTransform(translationX: 0, y: 0)
				self.setConstraintsForShowCase()
			}
			if sender.selectedSegmentIndex == 0 {
				self.showCaseOfBasemapsForMapView.transform = CGAffineTransform.identity
				self.showCaseOfBasemapsForSceneView.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
				self.setConstraintsForShowCase()
			}
		})
	}
	
	private func applyBasemap() {
		mapViewController.mapView.map?.basemap = BasemapPickerViewController.selectedBasemapForMapView
		mapViewController.sceneViewController.sceneView.scene?.basemap = BasemapPickerViewController.selectedBasemapForSceneView
	}
	
	private func setDelegate() {
		transitioningDelegate = self
	}
	
	private func placeSubViews() {
		view.addSubviews(
			dismissButton, navigationBarDivider,
			geoViewSegmentedControllPicker,
			showCaseOfBasemapsForMapView,
			showCaseOfBasemapsForSceneView
		)
	}
	
	private func setConstraints() {
		let safeArea = view.safeAreaLayoutGuide
		let margins = view.layoutMarginsGuide
		
		NSLayoutConstraint.activate([
			dismissButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
			dismissButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: Measurements.getPadding()),
			
			navigationBarDivider.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
			navigationBarDivider.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: Measurements.getPadding()),
			navigationBarDivider.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
			navigationBarDivider.heightAnchor.constraint(equalToConstant: navigationBarDivider.DEFAULT_HEIGHT),
			
			geoViewSegmentedControllPicker.centerYAnchor.constraint(equalTo: navigationBarDivider.centerYAnchor),
			geoViewSegmentedControllPicker.centerXAnchor.constraint(equalTo: navigationBarDivider.centerXAnchor),
		])
		
		setConstraintsForShowCase()
	}
	
	private func setConstraintsForShowCase() {
		let margins = view.layoutMarginsGuide
		
		if geoViewSegmentedControllPicker.selectedSegmentIndex == 0 {
			self.showCaseOfBasemapsForSceneView.isHidden = true
			self.showCaseOfBasemapsForSceneView.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
			
			NSLayoutConstraint.activate([
				showCaseOfBasemapsForMapView.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
				showCaseOfBasemapsForMapView.topAnchor.constraint(equalTo: geoViewSegmentedControllPicker.bottomAnchor, constant: Measurements.getPaddingBetweenViews()),
				showCaseOfBasemapsForMapView.widthAnchor.constraint(equalTo: margins.widthAnchor)
			])
		} else {
			self.showCaseOfBasemapsForSceneView.isHidden = false
			
			NSLayoutConstraint.activate([
				showCaseOfBasemapsForSceneView.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
				showCaseOfBasemapsForSceneView.topAnchor.constraint(equalTo: geoViewSegmentedControllPicker.bottomAnchor, constant: Measurements.getPaddingBetweenViews()),
				showCaseOfBasemapsForSceneView.widthAnchor.constraint(equalTo: margins.widthAnchor)
			])
		}
	}
}

extension BasemapPickerViewController: UIViewControllerTransitioningDelegate {
	
	override func viewWillDisappear(_ animated: Bool) {
		applyBasemap()
		changeGeoView()
	}
}
