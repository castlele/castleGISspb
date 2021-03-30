//
//  ShowcaseView.swift
//  castleGISspb
//
//  Created by Nikita Semenov on 12.03.2021.
//

import Foundation
import UIKit

final class ShowcaseView: UIView {
	
	lazy var totalHeight : CGFloat = {
		let rawSelfHeight = (Measurements.getStandardButtonSize() * 2 + CGFloat(20)) * CGFloat(amountOfElements / 2)
		var amount : Int
		
		if amountOfElements == 0 {
			amount = 4
		} else {
			amount = amountOfElements
		}
		
		let paddingsHeight = CGFloat(amount / 2 + 1) * Measurements.getPadding()
		let selfHeight = rawSelfHeight + paddingsHeight
		
		return selfHeight
	}()
	
	private var views = [UIView]()
	private var labels = [UILabel]()
	private var indexOfSelected = 0
	
	private var amountOfElements: Int {
		views.count
	}
	
	private override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	convenience init(views: [UIView], labels: [UILabel]) {
		self.init(frame: .zero)
		
		guard views.count == labels.count else {
			fatalError("Amount of views: \(views.count) should be equal to amount of labels: \(labels.count)")
		}
		
		self.views = views
		self.labels = labels
		
		setupViews()
		placeSubViews()
		setupConstraints()
	}
	
	private func setupViews() {
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = ColorPicker.getSubMainColor()
		layer.cornerRadius = Measurements.getCornerRadius()
		
		for index in 0..<amountOfElements {
			setupViews(withIndex: index)
		}
		
		selectView()
	}
	
	private func setupViews(withIndex i: Int) {
		let view = views[i]
		let label = labels[i]
		
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = Measurements.getCornerRadius()
		view.layer.borderWidth = 3
		view.layer.borderColor = ColorPicker.getSubAccentColor().cgColor
		addTargetIfButton(for: view)
		
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.boldSystemFont(ofSize: 15)
		label.textColor = ColorPicker.getSubAccentColor()
	}
	
	private func addTargetIfButton(for view: UIView) {
		guard let button = view as? UIButton else { return }
		
		button.addTarget(self, action: #selector(becomeSelected), for: .touchUpInside)
	}
	
	@objc private func becomeSelected(_ sender: UIButton) {
		labels[indexOfSelected].textColor = ColorPicker.getSubAccentColor()
		views[indexOfSelected].layer.borderColor = ColorPicker.getSubAccentColor().cgColor
		
		changeSelectedIndex(for: sender)
		
		sender.layer.borderColor = ColorPicker.getAccentColor().cgColor
		labels[indexOfSelected].textColor = ColorPicker.getAccentColor()
		changeBasemap(basemap: labels[indexOfSelected].text!)
	}
	
	private func changeSelectedIndex(for button: UIButton) {
		for index in 0..<amountOfElements {
			if views[index] === button {
				indexOfSelected = index
			}
		}
	}
	
	private func changeBasemap(basemap name: String) {
		if let basemap = BasemapPickerViewController.basemapsForMapView[name] {
			BasemapPickerViewController.selectedBasemapForMapView = basemap
		}
		if let basemap = BasemapPickerViewController.basemapsForSceneView[name] {
			BasemapPickerViewController.selectedBasemapForSceneView = basemap
		}
	}
	
	private func selectView() {
		views[indexOfSelected].layer.borderColor = ColorPicker.getAccentColor().cgColor
		labels[indexOfSelected].textColor = ColorPicker.getAccentColor()
	}
	
	private func placeSubViews() {
		for index in 0..<amountOfElements {
			addSubviews(views[index], labels[index])
		}
	}
	
	private func setupConstraints() {
		setConstraintsForSelf()
		
		for index in 0..<amountOfElements {
			setConstraints(for: index)
		}
	}
	
	private func setConstraintsForSelf() {
		NSLayoutConstraint.activate([
			self.heightAnchor.constraint(equalToConstant: totalHeight)
		])
	}
	
	private func setConstraints(for index: Int) {
		if index % 2 == 0 {
			setConstraintsForEvenViews(index)
		} else {
			setConstraintsForOddViews(index)
		}
	}
	
	private func setConstraintsForEvenViews(_ index: Int) {
		let margins = layoutMarginsGuide
		let uiView = views[index]
		let label = labels[index]
		
		NSLayoutConstraint.activate([
			uiView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: Measurements.getPadding()),
			uiView.topAnchor.constraint(equalTo: index == 0 ? self.topAnchor : labels[index % 2].bottomAnchor, constant: Measurements.getPadding()),
			uiView.heightAnchor.constraint(equalToConstant: Measurements.getStandardButtonSize() * 2),
			uiView.widthAnchor.constraint(equalToConstant: Measurements.getStandardButtonSize() * 2),
			
			label.centerXAnchor.constraint(equalTo: uiView.centerXAnchor),
			label.topAnchor.constraint(equalTo: uiView.bottomAnchor)
		])
	}
	
	private func setConstraintsForOddViews(_ index: Int) {
		let margins = layoutMarginsGuide
		let uiView = views[index]
		let label = labels[index]
		
		NSLayoutConstraint.activate([
			uiView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -Measurements.getPadding()),
			uiView.topAnchor.constraint(equalTo: index == 1 ? self.topAnchor : labels[index % 2].bottomAnchor, constant: Measurements.getPadding()),
			uiView.heightAnchor.constraint(equalToConstant: Measurements.getStandardButtonSize() * 2),
			uiView.widthAnchor.constraint(equalToConstant: Measurements.getStandardButtonSize() * 2),
			
			label.centerXAnchor.constraint(equalTo: uiView.centerXAnchor),
			label.topAnchor.constraint(equalTo: uiView.bottomAnchor)
		])
	}
}
