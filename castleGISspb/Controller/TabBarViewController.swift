//
//  TabBarViewController.swift
//  castleGISspb
//
//  Created by Nikita Semenov on 01.04.2021.
//

import UIKit
import FancyTabBarController

class TabBarViewController: FancyTabBarViewController {
	
	let mapVC = MapViewController()
	let sceneVC = SceneViewController()
	
	let mapBut = MapButtonView()
	let sceneBut = MapButtonView()

	private var blankView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		childViewController = [mapVC, sceneVC]
		tabBarItems = [mapBut, sceneBut]
		tabBarColor = ColorPicker.getSubMainColor()
		highlighterColor = ColorPicker.getAccentColor()
		
		initialization()
		
		tabBarView.setShadow(Shadow())

		setupBlankView()
		addSubViews()
		setConstraints()
}

	private func setupBlankView() {
		let blankViewFrame = CGRect(
			x: 0, 
			y: 0, 
			width: view.frame.width, 
			height: view.safeAreaLayoutGuide.layoutFrame.height
		)
		blankView = UIView(frame: blankViewFrame)
		blankView.translatesAutoresizingMaskIntoConstraints = false
		blankView.backgroundColor = ColorPicker.getSubMainColor()
	}

	private func addSubViews() {
		view.addSubviews(blankView)
	}

	private func setConstraints() {
		NSLayoutConstraint.activate([
			blankView.topAnchor.constraint(equalTo: tabBarView.bottomAnchor),
			blankView.heightAnchor.constraint(equalToConstant: 50),
			blankView.widthAnchor.constraint(equalTo: view.widthAnchor),
		])
	}
}
