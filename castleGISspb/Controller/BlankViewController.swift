//
//  BlankViewController.swift
//  castleGISspb
//
//  Created by Nikita Semenov on 26.03.2021.
//

import UIKit

final class TabBarView: UIView {
	
	let height: CGFloat = 70
	var width : CGFloat {
		UIScreen.main.bounds.width
	}
	
	var tabBarItems : [UIView]!
	
	var paddingBetweenItems : CGFloat {
		(width - CGFloat(tabBarItems.count) * (Measurements.getStandardButtonSize())) / CGFloat(tabBarItems.count + 1)
	}
	
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	required override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	convenience init(items: [UIView]) {
		self.init(frame: .zero)
		
		tabBarItems = items
		translatesAutoresizingMaskIntoConstraints = false
		setConstraints()
		print(paddingBetweenItems)
	}
	
	override func draw(_ rect: CGRect) {
		let rectangle = UIBezierPath(rect: CGRect(x: 0, y: frame.height - height, width: width, height: height))
		
		ColorPicker.getSubMainColor().setFill()
		rectangle.fill()
	}
	
	func setConstraints() {
		for (number, item) in tabBarItems.enumerated() {
			addSubview(item)
			if number == 0 {
				NSLayoutConstraint.activate([
					item.leadingAnchor.constraint(equalTo: leadingAnchor, constant: paddingBetweenItems),
					item.heightAnchor.constraint(equalToConstant: Measurements.getStandardButtonSize() - 15),
					item.widthAnchor.constraint(equalToConstant: Measurements.getStandardButtonSize()),
					item.centerYAnchor.constraint(equalTo: topAnchor)
				])
			} else {
				NSLayoutConstraint.activate([
					item.leadingAnchor.constraint(equalTo: tabBarItems[number - 1].trailingAnchor, constant: paddingBetweenItems),
					item.heightAnchor.constraint(equalToConstant: Measurements.getStandardButtonSize() - 15),
					item.widthAnchor.constraint(equalToConstant: Measurements.getStandardButtonSize()),
					item.centerYAnchor.constraint(equalTo: topAnchor)
				])
			}
			
		}
	}
}


// MARK:- MapButton
final class MapButton: UIButton {
	
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
		setupTarget()
		translatesAutoresizingMaskIntoConstraints = false
	}
	
	func setupTarget() {
		addTarget(self, action: #selector(openCloseMap), for: .touchUpInside)
	}
	
	@objc func openCloseMap(_ sender: UIButton) {
		isActivated.toggle()
		setNeedsDisplay()
	}
	
	override func draw(_ rect: CGRect) {
		backgroundColor = .clear
		
		
		CATransaction.begin()
		CATransaction.setAnimationDuration(2.0)
		CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))

		UIView.animate(withDuration: 2) {
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

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = ColorPicker.getMainColor()
		
		mapButton = MapButton()
		let mapButtonTwo = MapButton()
		let mapButtonThree = MapButton()
		tabBar = TabBarView(items: [mapButton, mapButtonTwo, mapButtonThree])
		
		view.addSubviews(tabBar)
		setConstraints()
    }
	
	func setConstraints() {
//		let safeArea = view.safeAreaLayoutGuide
		
		NSLayoutConstraint.activate([
			tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tabBar.heightAnchor.constraint(equalToConstant: tabBar.height),
			tabBar.widthAnchor.constraint(equalTo: view.widthAnchor),
			tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
		])
	}
}
