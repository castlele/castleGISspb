//
//  NetworkRequester.swift
//  castleGIS
//
//  Created by Nikita Semenov on 03.03.2021.
//

import Foundation

struct NetworkRequestor {
	
	static func makeRequest<T>(to url: String, with completition: @escaping ([T]) -> Void) where T: Codable {
		guard let url = URL(string: url) else {
			print("ERROR>> Can't convert string to URL")
			return
		}
		
		makeSession(with: URLRequest(url: url), completition: completition, url: url)
	}
	
	static func makeSession<T>(with request: URLRequest, completition: @escaping ([T]) -> Void, url: URL) where T: Codable {
		URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data else {
				print("ERROR>> Don't recieve any data")
				return
			}
			
			JSONParser.parseJSON(from: data, with: completition, url: url)
			
		}.resume()
	}
}

struct JSONParser {
	
	static func parseJSON<T>(from data: Data, with completition: @escaping ([T]) -> Void, url: URL) where T: Codable {
		do {
			let decoder = JSONDecoder()
			let decodedJSON = try decoder.decode([T].self, from: data)
			completition(decodedJSON)
			
		} catch {
			print("ERROR>> Can't decode Data to JSON")
		}
	}
}
