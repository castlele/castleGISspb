//
//  FormView.swift
//  castleGIS
//
//  Created by Nikita Semenov on 06.03.2021.
//

import Foundation
import UIKit

class SectionView: UIView {
	
	private let CORNER_RADIUS : CGFloat = Measurements.getCornerRaduis()
	private let PADDING_BETWEEN_DIVIDER : CGFloat = 4
	private let ROW_HEIGHT : CGFloat = 20
	private var ROWS_TEXT_FONT = UIFont.boldSystemFont(ofSize: 17)
	
	private var labelsOfRows: [String] = []
	private var actionsOfRows: [Selector] = []
	private var rows: [RowView] = []
	
	private var rowsColor: UIColor?
	private var rowsTextColor: UIColor?
	private var rowsCheckBoxColor: UIColor?
	
	private var dividers = [DividerView]()
	
	private override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	convenience init?(labels: [String], actions: [Selector]) {
		self.init(frame: .zero)
		
		isContainsTheSameAmountOfElements(labels, actions)
		
		labelsOfRows = labels
		actionsOfRows = actions
	}
	
	func customizeSection(bgColor: UIColor?, rowsColor: UIColor?, rowsTextColor: UIColor?, rowsCheckBoxColor: UIColor?) {
		self.backgroundColor = bgColor
		self.rowsColor = rowsColor
		self.rowsTextColor = rowsTextColor
		self.rowsCheckBoxColor = rowsCheckBoxColor
	}
	
	func makeSection() {
		setupViews()
	}
}

// MARK:- Helper functions
extension SectionView {
	
	private func setupViews() {
		self.layer.cornerRadius = CORNER_RADIUS
		
		makeRows()
		makeDividors()
		constraintsSetup()
	}
	
	private func makeDividors() {
		for _ in 0..<rows.count {
			let divider = DividerView()
			dividers.append(divider)
		}
	}
	
	private func makeRows() {
		for index in 0..<actionsOfRows.count {
			let (label, action) = getLabelAndAction(for: index)
			let rowView = RowView(label, bgColor: rowsColor, action: action)
			
			setupRowView(rowView)
			
			rows.append(rowView)
		}
	}
	
	private func constraintsSetup() {
		enableConstraints()
		setSectionsConstraints()
		addRowsAsSubviewsAndSetupConstraints()
	}
	
	private func addRowsAsSubviewsAndSetupConstraints() {
		let FIRST_ROW = 1
		
		var prev = UIView()
		
		for row in rows {
			self.addSubview(row)
			
			if self.subviews.count == FIRST_ROW {
				setConstraints(for: self, next: row)
				
			} else {
				setConstraints(for: prev, next: row)
			}
			prev = row
		}
	}
	
	private func setConstraints(for previous: UIView, next: UIView) {
		let previousIsSelf = previous === self ? true : false
		var divider = DividerView()
		
		if !previousIsSelf {
			divider = setupDividor(for: previous, next: next)
		}
		
		NSLayoutConstraint.activate([
			next.topAnchor.constraint(equalTo: previousIsSelf ? self.topAnchor : divider.bottomAnchor, constant:  previousIsSelf ? Measurements.getPadding() : PADDING_BETWEEN_DIVIDER),
			next.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			next.heightAnchor.constraint(equalToConstant: ROW_HEIGHT),
			next.leadingAnchor.constraint(equalTo: self.leadingAnchor)
		])
	}
	
	private func setupDividor(for previous: UIView, next: UIView) -> DividerView {
		let divider = dividers.popLast()!
		
		self.addSubview(divider)
		
		setDividorConstrains(for: divider, previous: previous, next: next)
		
		return divider
	}
	
	private func setDividorConstrains(for divider: DividerView, previous: UIView, next: UIView) {
		NSLayoutConstraint.activate([
			divider.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			divider.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: PADDING_BETWEEN_DIVIDER),
			divider.heightAnchor.constraint(equalToConstant: divider.DEFAULT_HEIGHT),
			divider.widthAnchor.constraint(equalTo: self.widthAnchor)
		])
	}
	
	private func setSectionsConstraints() {
		let multiplier = CGFloat(rows.count)
		let sectionHeight = multiplier * ROW_HEIGHT + Measurements.getPadding() * (multiplier + 1)
		
		NSLayoutConstraint.activate([
			self.heightAnchor.constraint(equalToConstant: sectionHeight)
		])
	}
	
	private func isContainsTheSameAmountOfElements(_ a: [Any], _ b: [Any]) {
		guard a.count == b.count else {
			fatalError()
		}
	}
	
	private func getLabelAndAction(for index: Int) -> (String, Selector) {
		(labelsOfRows[index], actionsOfRows[index])
	}
	
	private func setupRowView(_ rowView: RowView) {
		rowView.setupLabel(textColor: rowsTextColor, font: ROWS_TEXT_FONT)
		rowView.setupCheckBox(tintColor: rowsCheckBoxColor)
	}
	
	private func enableConstraints() {
		self.translatesAutoresizingMaskIntoConstraints = false
	}
}
