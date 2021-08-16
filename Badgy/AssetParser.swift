//
//  AssetParser.swift
//  BadgeIt
//
//  Created by Shane Whitehead on 11/8/20.
//  Copyright © 2020 Swann Security. All rights reserved.
//

import Foundation
import AppKit

struct Image: Codable {
	let filename: String
	let idiom: String
	let size: String
	let scale: String
}

struct Asset: Codable {
	let images: [Image]
}

// Looking for paths ending in .appiconset

//let sourcePath = URL(fileURLWithPath: "/Users/shanew/Development/Swann/SwannSecurity/SwannSecurityApp/SwannSecurity/Assets/Assets.xcassets")

struct AssetParser {
	
	static func parse(source sourcePath: URL) throws -> [URL] {
		
		let children = try FileManager.default.contentsOfDirectory(at: sourcePath, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
		
		var appIconAssetSources: [URL] = []
		
		for child in children {
			if child.lastPathComponent.hasSuffix(".appiconset") {
				appIconAssetSources.append(child)
			}
		}
		
		var iconAssets: [URL] = []
		for asset in appIconAssetSources {
			let contents = asset.appendingPathComponent("Contents.json")
			let data = try Data(contentsOf: contents)
			let iconCatalog = try JSONDecoder().decode(Asset.self, from: data)
			
			for iconAsset in iconCatalog.images {
				let url = asset.appendingPathComponent(iconAsset.filename)
				iconAssets.append(url)
			}
		}
		
		return iconAssets
	}
	
}
