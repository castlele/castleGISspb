//
//  SettingsViewController.swift
//  castleGIS
//
//  Created by Nikita Semenov on 03.03.2021.
//

import UIKit
import ArcGIS

final class SettingsViewController: UIViewController {
	
	private let deviceLanguage = NSLocale.current.languageCode
	
	let labels = [
		NSLocalizedString("Districts' highlighting", comment: ""),
		NSLocalizedString("Districts' info", comment: ""),
		NSLocalizedString("Magnifier", comment: ""),
		NSLocalizedString("Grid", comment: "")
	]
	private let actions = [#selector(addAndRemoveDistrictsRegions), #selector(addAndRemoveDistrictsCenters), #selector(showMagnifier), #selector(showGrid)]
	
	var mapViewController : MapViewController!
	
	let districtModel = DistrictModel()
	
	private var sectionView: SectionView!
	private var navigationBarDivider: DividerView!
	
	private var dismissButton: ButtonView = {
		let font = UIFont.boldSystemFont(ofSize: 20)
		let label = NSLocalizedString("< Back", comment: "")
		let button = ButtonView(bgColor: nil, titleColor: ColorPicker.getSubAccentColor(), font: font, text: label, isShadow: false)

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
		dismissButton.setTitleColor(ColorPicker.getSubAccentColor(), for: .normal)
		
		setupSectionView()
		setupDividerView()

		setButtonsTargets()
	}
	
	private func setupSectionView() {
		for i in labels {
			print(i)
		}
		sectionView = SectionView(labels: labels, actions: actions)
		sectionView.customizeSection(bgColor: ColorPicker.getSubMainColor(), rowsColor: nil, rowsTextColor: ColorPicker.getStandardTextColor(), rowsCheckBoxColor: ColorPicker.getAccentColor())
		sectionView.makeSection()
	}
	
	@objc private func addAndRemoveDistrictsRegions(_ sender: UIButton) {
		let DICTIONARY_KEY = mapViewController?.DISTRICTS_REGIONS_KEY
		var overlays = [String: AGSGraphic]()
		let districts = districtModel.getDistrictsGraphics()
		
		for (districtName, graphics) in districts {
			overlays[districtName] = graphics.polygon
		}
		
		mapViewController.addAndRemoveGraphics(overlays, withKey: DICTIONARY_KEY!)
	}
	
	@objc private func addAndRemoveDistrictsCenters(_ sender: UIButton) {
		let DICTIONARY_KEY = mapViewController?.DISTRICTS_CENTERS_KEY
		var overlays = [String: AGSGraphic]()
		let districts = districtModel.getDistrictsGraphics()
		
		for (districtName, graphics) in districts {
			overlays[districtName] = graphics.centerPoint
		}
		
		mapViewController.addAndRemoveGraphics(overlays, withKey: DICTIONARY_KEY!)
	}
	
	@objc private func showMagnifier(_ sender: UIButton) {
		showMagnifierForMapView()
	}
	
	private func showMagnifierForMapView() {
		if mapViewController.mapView.interactionOptions.isMagnifierEnabled {
			mapViewController.mapView.interactionOptions.isMagnifierEnabled = false
		} else {
			mapViewController.mapView.interactionOptions.isMagnifierEnabled = true
		}
	}
	
	@objc private func showGrid(_ sender: UIButton) {
		setGridForMapView()
	}
	
	private func setGridForMapView() {
		if mapViewController.mapView.grid == nil {
			let grid = AGSLatitudeLongitudeGrid()
			grid.labelFormat = .decimalDegrees
			
			guard let textSymbol = grid.textSymbol(forLevel: 0) as? AGSTextSymbol else { return }
			textSymbol.color = ColorPicker.getSubAccentColor()
			
			guard let lineSymbol = grid.lineSymbol(forLevel: 0) as? AGSLineSymbol else { return }
			lineSymbol.color = ColorPicker.getSubAccentColor()
			
			mapViewController.mapView.grid = grid
			
		} else {
			mapViewController.mapView.grid = nil
		}
	}
	
	private func setupDividerView() {
		navigationBarDivider = DividerView(with: ColorPicker.getAccentColor())
	}
	
	private func setButtonsTargets() {
		dismissButton.addTarget(MapViewController(), action: #selector(moveBackToGeoView), for: .touchUpInside)
	}
	
	@objc private func moveBackToGeoView(_ selector: UIButton) {
		navigationController?.popViewController(animated: true)
	}
	
	private func placeSubViews() {
		view.addSubviews(
			sectionView, dismissButton, navigationBarDivider
		)
	}
	
	private func setConstraints() {
		let margins = view.layoutMarginsGuide
		let safeArea = view.safeAreaLayoutGuide
		
		NSLayoutConstraint.activate([
			dismissButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Measurements.getPadding() * 2),
			dismissButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Measurements.getPadding()),
			
			sectionView.topAnchor.constraint(equalTo: navigationBarDivider.bottomAnchor, constant: Measurements.getPaddingBetweenViews()),
			sectionView.widthAnchor.constraint(equalTo: margins.widthAnchor),
			sectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
			
			navigationBarDivider.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
			navigationBarDivider.topAnchor.constraint(equalTo: dismissButton.bottomAnchor),
			navigationBarDivider.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
			navigationBarDivider.heightAnchor.constraint(equalToConstant: navigationBarDivider.DEFAULT_HEIGHT)
		])
	}
}
