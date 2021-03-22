//
//  Endpoint.swift
//  castleGIS
//
//  Created by Nikita Semenov on 03.03.2021.
//

import Foundation

struct Endpoint {
	
	static private let urlToDistrictsJSON = "https://api.npoint.io/8c844cb201e72006c9be"
	static private let urlToDistrictsWikiInfo = "https://api.npoint.io/9a63d6e1d88196855503"
	
	static func getUrlToDistrictsJSON() -> String {
		urlToDistrictsJSON
	}
	
	static func getUrlToDistrictsWikiInfo() -> String {
		urlToDistrictsWikiInfo
	}
}

// MARK:- All St. Petersburg Regions
enum Region: String, CaseIterable {
	case admiralteysky = "258578612"
	case vasileostrovsky = "258987562"
	case vyborgsky = "257097574"
	case kalininsky = "258045792"
	case kirovsky = "258578977"
	case kolpinsky = "256707067"
	case krasnogvardeysky = "258888987"
	case krasnoselsky = "258695614"
	case krondshtadsky = "257036721"
	case kyrortny = "258046007"
	case moskovsky = "256771517"
	case nevsky = "258461741"
	case petrogradsky = "259276818"
	case petrodvorcovy = "258805007"
	case primorsky = "258876915"
	case pyshkinsky = "258424883"
	case frunzensky = "258120066"
	case centralny = "258288360"
}
