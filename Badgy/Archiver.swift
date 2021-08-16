//
//  Archiver.swift
//  BadgeIt
//
//  Created by Shane Whitehead on 11/8/20.
//  Copyright © 2020 Swann Security. All rights reserved.
//

import Foundation

class Archive {
	
	static func backup(assets: [URL]) throws {
		let fileManager = FileManager.default
		for asset in assets {
			let backup = asset.backup
			guard !fileManager.fileExists(atPath: backup.path) else { continue }
			
			print("Back up \(asset)".white)
			print("     to \(backup)".white)

			try fileManager.copyItem(at: asset, to: backup)
		}
	}
	
	static func restore(assets: [URL]) throws {
		let fileManager = FileManager.default
		for asset in assets {
			let backup = asset.backup
			guard fileManager.fileExists(atPath: backup.path) else { continue }
			
			print("Restore \(backup)".white)
			print("     to \(asset)".white)

			try fileManager.removeItem(at: asset)
			try fileManager.copyItem(at: backup, to: asset)
			try fileManager.removeItem(at: backup)
		}
	}

	static func removeBackups(for assets: [URL]) throws {
		let fileManager = FileManager.default
		for asset in assets {
			let backup = asset.backup
			guard fileManager.fileExists(atPath: backup.path) else { continue }
			
			print("Remove backup \(backup)".yellow)

			try fileManager.removeItem(at: backup)
		}
	}

}
