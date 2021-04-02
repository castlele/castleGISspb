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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		childViewController = [mapVC, sceneVC]
		tabBarItems = [mapBut, sceneBut]
		tabBarColor = ColorPicker.getSubMainColor()
		highlighterColor = ColorPicker.getAccentColor()
		
		initialization()
	}
}
