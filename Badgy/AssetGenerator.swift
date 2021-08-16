//
//  AssetGenerator.swift
//  BadgeIt
//
//  Created by Shane Whitehead on 22/8/20.
//  Copyright © 2020 Swann Security. All rights reserved.
//

import Foundation

struct AssetGenerator {
	
	static func generate(from source: String) throws -> String {
		let currentPath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
		let sourceURL = currentPath.appendingPathComponent(source)
		
		return try generate(from: sourceURL)
	}
	
	static func generate(from source: URL) throws -> String {
		let data = try Data(contentsOf: source)
		return data.base64EncodedString()
	}
	
}
