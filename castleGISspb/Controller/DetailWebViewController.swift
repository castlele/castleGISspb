//
//  DetailViewController.swift
//  castleGISspb
//
//  Created by Nikita Semenov on 14.03.2021.
//

import Foundation
import UIKit
import WebKit

final class DetailWebViewController: UIViewController, WKNavigationDelegate {
	
	private var webView : WKWebView!
	var urlToLoad : URL!
	
	// MARK:- loadView()
	override func loadView() {
		setupViews()
	}
	
	private func setupViews() {
		setupWebView()
	}
	
	private func setupWebView() {
		webView = WKWebView()
		webView.navigationDelegate = self
		
		view = webView
	}
	
	// MARK:- viewDidLoad()
	override func viewDidLoad() {
		super.viewDidLoad()
		webView.load(URLRequest(url: urlToLoad))
		webView.allowsBackForwardNavigationGestures = true
	}
}
