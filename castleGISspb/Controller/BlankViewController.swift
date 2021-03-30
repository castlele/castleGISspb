//
//  BlankViewController.swift
//  castleGISspb
//
//  Created by Nikita Semenov on 26.03.2021.
//

import UIKit

protocol TabBarItem: UIButton {
	var isActivated: Bool { get set }
}

final class TabBarView: UIView {
	
	let height: CGFloat = 70
	var width: CGFloat {
		UIScreen.main.bounds.width
	}
	
	var tabBarItems: [TabBarItem]!
	
	lazy var circle: UIView = {
		let size = Measurements.getStandardButtonSize()
		let circle = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
		circle.translatesAutoresizingMaskIntoConstraints = false
		circle.layer.cornerRadius = Measurements.getCornerRadius() + 10
		circle.backgroundColor = ColorPicker.getAccentColor()
		addSubview(circle)
		return circle
	}()

	var selectedIndex: Int = 0 {
		willSet {
			if newValue != selectedIndex {
				UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [.curveEaseInOut, .preferredFramesPerSecond60]) {
					
					self.tabBarItems[newValue].transform = CGAffineTransform(translationX: 0, y: -self.height / 2)
					self.deActivate(despite: self.tabBarItems[newValue])
					self.circle.center = CGPoint(x: self.tabBarItems[newValue].center.x, y: self.height)
				}
			}
		}
	}
	
	func deActivate(despite item: TabBarItem) {
		for i in tabBarItems {
			if i !== item {
				i.transform = CGAffineTransform.identity
			}
		}
	}
	
	var paddingBetweenItems: CGFloat {
		(width - CGFloat(tabBarItems.count) * (Measurements.getStandardButtonSize() - 5)) / CGFloat(tabBarItems.count + 1)
	}
	
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	required override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	convenience init(items: [TabBarItem]) {
		self.init(frame: .zero)
		
		tabBarItems = items
		translatesAutoresizingMaskIntoConstraints = false
		findSelected()
		addTargets()
		setConstraints()
		
	}
	
	// MARK:- Drawing
	override func draw(_ rect: CGRect) {
		let rec = UIBezierPath()
		rec.move(to: CGPoint(x: 0, y: 0))
		rec.addLine(to: CGPoint(x: width, y: 0))
		rec.addLine(to: CGPoint(x: width, y: height))
		rec.addLine(to: CGPoint(x: 0, y: height))
		rec.close()
		
		UIColor.white.withAlphaComponent(0).setFill()
		rec.fill()
		
		let rectangle = UIBezierPath()
		rectangle.move(to: CGPoint(x: 0, y: height / 2.5))
		rectangle.addLine(to: CGPoint(x: width, y: height / 2.5))
		rectangle.addLine(to: CGPoint(x: width, y: height))
		rectangle.addLine(to: CGPoint(x: 0, y: height))
		rectangle.close()
		
		ColorPicker.getSubMainColor().setFill()
		rectangle.fill()
	}
	
	func findSelected() {
		for (index, item) in tabBarItems.enumerated() {
			if item.isActivated {
				selectedIndex = index
			}
		}
	}
	
	func addTargets() {
		for item in tabBarItems {
			item.addTarget(self, action: #selector(selectTabBarItem), for: .touchUpInside)
		}
	}
	
	@objc func selectTabBarItem(_ sender: UIButton) {
		if let item = tabBarItems.firstIndex(where: { $0 === sender }) {
			for (n, i) in tabBarItems.enumerated() {
				if n != item {
					i.isActivated = false
				}
				tabBarItems[item].isActivated = true
			}
		}
		findSelected()
		for item in tabBarItems {
			item.setNeedsDisplay()
		}
	}
	
	func setConstraints() {
		for (number, item) in tabBarItems.enumerated() {
			addSubview(item)
			if number == 0 {
				NSLayoutConstraint.activate([
					item.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Measurements.getPadding()),
					item.leadingAnchor.constraint(equalTo: leadingAnchor, constant: paddingBetweenItems),
					item.heightAnchor.constraint(equalToConstant: Measurements.getStandardButtonHeight()),
					item.widthAnchor.constraint(equalToConstant: Measurements.getStandardButtonWidth()),
					
				])
			} else {
				NSLayoutConstraint.activate([
					item.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Measurements.getPadding()),
					item.leadingAnchor.constraint(equalTo: tabBarItems[number - 1].trailingAnchor, constant: paddingBetweenItems),
					item.heightAnchor.constraint(equalToConstant: Measurements.getStandardButtonHeight()),
					item.widthAnchor.constraint(equalToConstant: Measurements.getStandardButtonWidth()),
				])
			}
			
			if number == selectedIndex {
				NSLayoutConstraint.activate([
					circle.centerXAnchor.constraint(equalTo: item.centerXAnchor),
					circle.centerYAnchor.constraint(equalTo: item.centerYAnchor),
					circle.heightAnchor.constraint(equalToConstant: Measurements.getStandardButtonSize() + 5),
					circle.widthAnchor.constraint(equalToConstant: Measurements.getStandardButtonSize() + 5),
				])
			}
			sendSubviewToBack(circle)
		}
	}
}


// MARK:- MapButton
final class MapButton: UIButton, TabBarItem {
	
	private struct Constants {
		static let indent : CGFloat = 10
	}
	
	lazy var points : Array<CGPoint> = {
		[
			CGPoint(x: 1, y: height - 1),
			CGPoint(x: horizontalIndent, y: height - Constants.indent),
			CGPoint(x: horizontalIndent * 2, y: height - 1),
			CGPoint(x: horizontalIndent * 3, y: height - Constants.indent),
			CGPoint(x: horizontalIndent * 3, y: 1),
			CGPoint(x: horizontalIndent * 2, y: Constants.indent),
			CGPoint(x: horizontalIndent, y: 1),
			CGPoint(x: 1, y: Constants.indent)
		]
	}()
	
	var height: CGFloat {
		frame.height
	}
	
	var width: CGFloat {
		frame.width
	}
	
	var horizontalIndent: CGFloat {
		frame.width / 4
	}
	
	var isActivated: Bool = true
	
	override required init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	convenience init() {
		self.init(frame: .zero)
		
		translatesAutoresizingMaskIntoConstraints = false
	}

	
	override func draw(_ rect: CGRect) {
		backgroundColor = .clear
		
		
		CATransaction.begin()
		CATransaction.setAnimationDuration(0.5)
		CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))

		UIView.animate(withDuration: 5) {
			if self.isActivated {
				self.drawOpenMap()
			} else {
				self.drawCloseMap()
			}
		}
		
		let cornerAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
		
		layer.add(cornerAnimation, forKey: #keyPath(CALayer.transform))

		
		CATransaction.commit()

	}
	
	func drawOpenMap() {
		drawFirstPart()
		drawSecondPart()
		drawThirdPart()
	}
	
	func drawCloseMap() {
		drawSecondPart()
	}
	
	func drawFirstPart() {
		let firstPart = UIBezierPath()
		firstPart.move(to: points[0])
		firstPart.addLine(to: points[1])
		firstPart.addLine(to: points[6])
		firstPart.addLine(to: points[7])
		firstPart.addLine(to: points[0])
		firstPart.addLine(to: points[1])
		
		ColorPicker.getSubAccentColor().setStroke()
		firstPart.lineWidth = 2
		firstPart.lineJoinStyle = .round
		firstPart.stroke()
	}
	
	func drawSecondPart() {
		let secondPart = UIBezierPath()
		secondPart.move(to: points[1])
		secondPart.addLine(to: points[2])
		secondPart.addLine(to: points[5])
		secondPart.addLine(to: points[6])
		secondPart.addLine(to: points[1])
		secondPart.addLine(to: points[2])
		
		ColorPicker.getSubAccentColor().setStroke()
		secondPart.lineWidth = 2
		secondPart.lineJoinStyle = .round
		secondPart.stroke()
	}
	
	func drawThirdPart() {
		let thirdPart = UIBezierPath()
		thirdPart.move(to: points[2])
		thirdPart.addLine(to: points[3])
		thirdPart.addLine(to: points[4])
		thirdPart.addLine(to: points[5])
		thirdPart.addLine(to: points[2])
		thirdPart.addLine(to: points[3])
		
		ColorPicker.getSubAccentColor().setStroke()
		thirdPart.lineWidth = 2
		thirdPart.lineJoinStyle = .round
		thirdPart.stroke()
	}
	
	@objc func changeImage(_ sender: UIButton) {
		isActivated.toggle()
		addAnimation()
	}
	
	func addAnimation() {
		if !isActivated {
			UIView.animate(withDuration: 2) {
				let imageConfig = UIImage.SymbolConfiguration(pointSize: 50)
				self.setImage(UIImage(systemName: "map.fill", withConfiguration: imageConfig), for: .normal)
			}
			
			
		} else {
			UIView.animate(withDuration: 2) {
				let imageConfig = UIImage.SymbolConfiguration(pointSize: 50)
				self.setImage(UIImage(systemName: "map", withConfiguration: imageConfig), for: .normal)
			}
		}
	}
}

// MARK:- ViewController
class BlankViewController: UIViewController {
	
	var tabBar: TabBarView!
	var mapButton: MapButton!
	
	lazy var mapVC: MapViewController = {
		let mapVC = MapViewController()
		addChild(mapVC)
		view.addSubview(mapVC.view)
		view.sendSubviewToBack(mapVC.view)
		mapVC.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 50)
		mapVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		mapVC.didMove(toParent: self)
		return mapVC
	}()
	
	lazy var sceneVC: SceneViewController = {
		let sceneVC = SceneViewController()
		addChild(sceneVC)
		view.addSubview(sceneVC.view)
		view.sendSubviewToBack(sceneVC.view)
		sceneVC.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 50)
		sceneVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		sceneVC.didMove(toParent: self)
		return sceneVC
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = ColorPicker.getMainColor()
		
		mapButton = MapButton()
		mapButton.addTarget(nil, action: #selector(changeVC), for: .touchUpInside)
		let mapButtonTwo = MapButton()
		mapButtonTwo.isActivated = false
		mapButtonTwo.addTarget(nil, action: #selector(changeVC), for: .touchUpInside)
		tabBar = TabBarView(items: [mapButton, mapButtonTwo])
		tabBar.layer.backgroundColor = UIColor.clear.cgColor
		tabBar.isOpaque = false
		view.isOpaque = false
		
		
		view.addSubviews(tabBar)
		setConstraints()
    }
	
	@objc func changeVC(_ sender: UIButton) {
		if tabBar.selectedIndex == 0 {
			remove(vc: sceneVC)
			addChild(mapVC)
			view.addSubview(mapVC.view)
			view.sendSubviewToBack(mapVC.view)
			mapVC.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 17)
			mapVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			mapVC.didMove(toParent: self)
		} else {
			remove(vc: mapVC)
			addChild(sceneVC)
			view.addSubview(sceneVC.view)
			view.sendSubviewToBack(sceneVC.view)
			sceneVC.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 17)
			sceneVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			sceneVC.didMove(toParent: self)
		}
	}
	
	func remove(vc: UIViewController) {
		vc.willMove(toParent: nil)
		vc.view.removeFromSuperview()
		vc.removeFromParent()
	}
	
	func setConstraints() {
		let safeArea = view.safeAreaLayoutGuide
		
		NSLayoutConstraint.activate([
			tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tabBar.heightAnchor.constraint(equalToConstant: tabBar.height),
			tabBar.widthAnchor.constraint(equalTo: view.widthAnchor),
			tabBar.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
		])
	}
}
