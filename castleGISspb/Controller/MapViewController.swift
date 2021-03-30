//
//  ViewController.swift
//  castleGIS
//
//  Created by Nikita Semenov on 03.03.2021.
//

import UIKit
import ArcGIS

final class MapViewController: UIViewController {
	
	let DISTRICTS_REGIONS_KEY = "districtRegion"
	let DISTRICTS_CENTERS_KEY = "districtPoint"
	
	var graphicsOverlays: [String: [String: AGSGraphic]] = [:] // TODO: Make your own data struct
	
	private let graphicsOverlay = AGSGraphicsOverlay()
	
	var basemapPickerViewController : BasemapPickerViewController!
	var settingsViewController : SettingsViewController!
	var sceneViewController : SceneViewController!
	var detailWebViewController : DetailWebViewController!
	
	var mapView: AGSMapView = {
		MapView().map
	}()
	
	private var settingsButton : ButtonView = {
		let button = ButtonView(bgColor: ColorPicker.getMainColor(), tintColor: ColorPicker.getSubAccentColor(), image: "gear", isShadow: true)
		button.layer.cornerRadius = Measurements.getCornerRadius()
		
		return button
	}()
	
	var basemapPickerButton : ButtonView = {
		let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
		let button = ButtonView(bgColor: ColorPicker.getMainColor(), tintColor: ColorPicker.getSubAccentColor(), image: "square.stack.3d.down.forward.fill", imageConfiguration: imageConfig)
		button.layer.cornerRadius = Measurements.getCornerRadius()
		
		return button
	}()
	
	private var minusScaleButton: ButtonView = {
		let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)
		let button = ButtonView(image: "minus", imageConfiguration: imageConfig, isShadow: true)
		button.layer.cornerRadius = Measurements.getCornerRadius() - 5
		
		return button
	}()
	
	private var plusScaleButton: ButtonView = {
		let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)
		let button = ButtonView(image: "plus", imageConfiguration: imageConfig, isShadow: true)
		button.layer.cornerRadius = Measurements.getCornerRadius() - 5
		
		return button
	}()
	
	private var compassButton : CompassButton = {
		let button = CompassButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setShadow(Shadow())
		
		return button
	}()
	
	// MARK:- Public methods
	/// Adds and removes AGSGraphics from graphicsOverlay, depending on availability of graphics in overlay
	/// - Parameters:
	///   - graphics: Dictionary, where key is name or description of graphic, value is graphic itself
	///   - key: Key in  graphicsOverlays
	func addAndRemoveGraphics(_ graphics: [String: AGSGraphic], withKey key: String) {
		
		// Add graphics if they weren't deleted (e.i. they aren't in dictionary)
		if !removeGraphics(forKey: key) {
			addGraphicsToDictionary(graphics, withKey: key)
		}
		
		addGraphics()
	}
	
	private func removeGraphics(forKey key: String) -> Bool {
		if let _ = self.graphicsOverlays[key] {
			self.graphicsOverlays.removeValue(forKey: key)
			graphicsOverlay.graphics.removeAllObjects()
			return true
			
		} else {
			return false
		}
	}
	
	private func addGraphicsToDictionary(_ graphics: [String: AGSGraphic], withKey key: String) {
		self.graphicsOverlays[key] = graphics
	}
	
	private func addGraphics() {
		graphicsOverlay.graphics.removeAllObjects()
		
		if let points = graphicsOverlays[DISTRICTS_CENTERS_KEY] {
			graphicsOverlays.removeValue(forKey: DISTRICTS_CENTERS_KEY)
			iterateAndAddGraphics()
			iterateAndAdd(graphics: points)
			graphicsOverlays[DISTRICTS_CENTERS_KEY] = points
		} else {
			iterateAndAddGraphics()
		}
	}
	
	private func iterateAndAddGraphics() {
		for (_, overlays) in self.graphicsOverlays {
			for (_, overlay) in overlays {
				graphicsOverlay.graphics.add(overlay)
			}
		}
	}
	
	private func iterateAndAdd(graphics: [String: AGSGraphic]) {
		for (_, overlay) in graphics {
			graphicsOverlay.graphics.add(overlay)
		}
	}
	
	// MARK:- viewWillAppear()
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.setNavigationBarHidden(true, animated: animated)
		super.viewWillAppear(animated)
	}
	
	// MARK:- viewDidLoad()
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViewControllers()
		setupGraphicsOverlay()
		
		setupViews()
		placeSubviews()
		
		viewpointChangeHandler()
		
		setConstraints()
	}
	
	private func setupViewControllers() {
		setupSettingsVC()
		setupSceneVC()
		setupPickerSettingsVC()
	}
	
	private func setupSettingsVC() {
		settingsViewController = SettingsViewController()
		settingsViewController.mapViewController = self
	}
	
	private func setupSceneVC() {
		sceneViewController = SceneViewController()
		sceneViewController?.mapViewController = self
	}
	
	private func setupPickerSettingsVC() {
		basemapPickerViewController = BasemapPickerViewController()
		basemapPickerViewController.mapViewController = self
	}
	
	private func setupGraphicsOverlay() {
		graphicsOverlay.opacity = 0.55
		mapView.graphicsOverlays.add(graphicsOverlay)
	}
	
	private func setupViews() {
		setupMapView()
		setupButtonsTargets()
		
		assignDelegates()
	}
	
	private func setupMapView() {
		view = mapView
	}
	
	private func setupButtonsTargets() {
		settingsButton.addTarget(self, action: #selector(moveToSettingsVC), for: .touchUpInside)
		basemapPickerButton.addTarget(self, action: #selector(presentBasemapPickerVC), for: .touchUpInside)
		compassButton.addTarget(self, action: #selector(setRotationAngelToDefault), for: .touchUpInside)
		plusScaleButton.addTarget(self, action: #selector(scaleMapViewUp), for: .touchUpInside)
		minusScaleButton.addTarget(self, action: #selector(scaleMapViewDown), for: .touchUpInside)
	}
	
	@objc private func moveToSettingsVC(_ sender: UIButton) {
		navigationController?.pushViewController(settingsViewController, animated: true)
	}
	
	@objc private func presentBasemapPickerVC() {
		let showCaseHeight = ShowcaseView().totalHeight * 10
		let paddings = Measurements.getPadding() * 10
		let buttonHeight = Measurements.getStandardButtonHeight()
		let offset = view.frame.height - showCaseHeight - paddings - buttonHeight
		
		let transitionDelegate = InteractiveTransitionDelegate(from: self, to: basemapPickerViewController, withOffset: offset)
		basemapPickerViewController.modalPresentationStyle = .custom
		basemapPickerViewController.transitioningDelegate = transitionDelegate
		
		present(basemapPickerViewController, animated: true)
	}
	
	@objc private func setRotationAngelToDefault() {
		compassButton.transform = CGAffineTransform(rotationAngle: 0)
		mapView.setViewpointRotation(0)
	}
	
	@objc private func scaleMapViewUp(_ sender: UIButton) {
		DispatchQueue.main.async {
			self.mapView.setViewpointScale(self.mapView.mapScale - 150000)
		}
	}
	
	@objc private func scaleMapViewDown(_ sender: UIButton) {
		DispatchQueue.main.async {
			self.mapView.setViewpointScale(self.mapView.mapScale + 150000)
		}
	}
	
	private func assignDelegates() {
		mapView.touchDelegate = self
	}
	
	private func placeSubviews() {
		view.addSubviews(
			settingsButton, minusScaleButton, plusScaleButton,
			compassButton, basemapPickerButton
		)
	}
	
	private func viewpointChangeHandler() {
		self.mapView.viewpointChangedHandler = { [weak self] in
			DispatchQueue.main.async {
				self?.mapViewPointDidChange()
			}
		}
	}
	
	private func mapViewPointDidChange() {
		let rotationAngle = CGFloat(Double(-mapView.rotation) * Double.pi / 180)
		compassButton.transform = CGAffineTransform(rotationAngle: rotationAngle)
	}
	
	private func setConstraints() {
		let margins = view.layoutMarginsGuide
		
		NSLayoutConstraint.activate([
			settingsButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 15),
			settingsButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
			
			minusScaleButton.heightAnchor.constraint(equalToConstant: Measurements.getStandardButtonHeight()),
			minusScaleButton.widthAnchor.constraint(equalToConstant: Measurements.getStandardButtonHeight()),
			minusScaleButton.trailingAnchor.constraint(equalTo: compassButton.leadingAnchor, constant: -Measurements.getPadding()),
			minusScaleButton.centerYAnchor.constraint(equalTo: compassButton.centerYAnchor),
			
			plusScaleButton.heightAnchor.constraint(equalToConstant: Measurements.getStandardButtonHeight()),
			plusScaleButton.widthAnchor.constraint(equalToConstant: Measurements.getStandardButtonHeight()),
			plusScaleButton.trailingAnchor.constraint(equalTo: minusScaleButton.leadingAnchor, constant: -Measurements.getPadding()),
			plusScaleButton.centerYAnchor.constraint(equalTo: compassButton.centerYAnchor),
			
			compassButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
			compassButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: Measurements.getPaddingFromBottomMargin()),
			compassButton.widthAnchor.constraint(equalToConstant: Measurements.getStandardButtonWidth()),
			compassButton.heightAnchor.constraint(equalToConstant: Measurements.getStandardButtonWidth()),
			
			basemapPickerButton.centerYAnchor.constraint(equalTo: settingsButton.centerYAnchor),
			basemapPickerButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
			basemapPickerButton.heightAnchor.constraint(equalTo: settingsButton.heightAnchor),
			basemapPickerButton.widthAnchor.constraint(equalTo: settingsButton.widthAnchor)
		])
	}
}

// MARK:- Delegats
extension MapViewController: AGSGeoViewTouchDelegate {
	
	func geoView(_ geoView: AGSGeoView, didDoubleTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint, completion: @escaping (Bool) -> Void) {
		showLocationCalloutFor(geoView: geoView, mapPoint: mapPoint)
	}
	
	private func showLocationCalloutFor(geoView: AGSGeoView, mapPoint: AGSPoint) {
		if geoView.callout.isHidden {
			geoView.showLocationCallout(at: mapPoint)
		} else {
			geoView.callout.dismiss()
		}
	}
	
	func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
		let tolerance : Double = 20
		
		showDistrictsInfoCallout(geoView, screenPoint: screenPoint, mapPoint: mapPoint, tolerance: tolerance)
	}
	
	private func showDistrictsInfoCallout(_ geoView: AGSGeoView, screenPoint: CGPoint, mapPoint: AGSPoint, tolerance: Double) {
		mapView.identify(graphicsOverlay, screenPoint: screenPoint, tolerance: tolerance, returnPopupsOnly: false) { (result: AGSIdentifyGraphicsOverlayResult) in
			if let districtsName = self.identifyGraphicsOverlay(result: result) {
				self.showCalloutFor(geoView: geoView, graphic: result.graphics[0], mapPoint: mapPoint, withTitle: districtsName)
			}
		}
	}
	
	private func identifyGraphicsOverlay(result: AGSIdentifyGraphicsOverlayResult) -> String? {
		if let _ = result.error {
			return nil
			
		} else {
			if !result.graphics.isEmpty {
				let graphic = result.graphics[0]
				
				if let districtsName = self.findDistrictsName(forGraphic: graphic) {
					return districtsName
				}
			}
		}
		return nil
	}
	
	private func findDistrictsName(forGraphic g: AGSGraphic) -> String? {
		if let districtsNames = graphicsOverlays[DISTRICTS_CENTERS_KEY] {
			
			for (name, graphic) in districtsNames {
				if graphic === g {
					return name
				}
			}
		}
		
		return nil
	}
	
	private func showCalloutFor(geoView: AGSGeoView, graphic: AGSGraphic, mapPoint: AGSPoint, withTitle title: String) {
		if geoView.callout.isHidden {
			let url = getURLForName(forName: title)
			geoView.showCallout(withTitle: title, withGraphics: graphic, at: mapPoint, withInfoButton: setupInfoButtonWithURL(url))
		} else {
			geoView.callout.dismiss()
		}
	}
	
	private func getURLForName(forName name: String) -> URL? {
		let districtModel = settingsViewController.districtModel
		
		if let url = districtModel.getDistrictsWikiLinkBy(name: name) {
			return url
		} else {
			return nil
		}
	}
	
	private func setupInfoButtonWithURL(_ url: URL?) -> UIButton {
		let infoButton = UIButton()
		
		infoButton.tintColor = ColorPicker.getSubAccentColor()
		infoButton.setImage(setupInfoButtonImage(), for: .normal)
		
		infoButton.translatesAutoresizingMaskIntoConstraints = false
		
		initialSetupDetailWebVC(with: url)
	
		infoButton.addTarget(nil, action: #selector(showDetailWebVC), for: .touchUpInside)
		
		return infoButton
	}
	
	private func initialSetupDetailWebVC(with url: URL?) {
		if let url = url {
			setupDetailWebVC(with: url)
		} else {
			let defaultUrl = URL(string: "https://wikipedia.com")!
			setupDetailWebVC(with: defaultUrl)
		}
	}
	
	private func setupInfoButtonImage() -> UIImage {
		let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .heavy)
		let image = UIImage(systemName: "info.circle.fill", withConfiguration: imageConfig)
		return image!
	}
	
	@objc private func showDetailWebVC(_ sender: UIButton) {
		navigationController?.pushViewController(detailWebViewController, animated: true)
		navigationController?.setNavigationBarHidden(false, animated: true)
		navigationController?.navigationBar.backgroundColor = ColorPicker.getMainColor()
		navigationController?.navigationBar.tintColor = ColorPicker.getSubAccentColor()
		navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: self, action: nil)
	}
	
	private func setupDetailWebVC(with url: URL) {
		detailWebViewController = DetailWebViewController()
		detailWebViewController.urlToLoad = url
	}
}
