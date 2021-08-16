//
//  main.swift
//  BadgeIt
//
//  Created by Shane Whitehead on 10/8/20.
//  Copyright © 2020 Swann Security. All rights reserved.
//

import Foundation
import ArgumentParser
import Rainbow
import AppKit

struct BadgeIt: ParsableCommand {
	
	@Flag(help: "Back up the original App icons (if not already done)")
	var backup = false
	
	@Flag(help: "Restore the original App icons (if back up exists - overwrites the existing icons)")
	var restore = false

	@Flag(help: "Remove backups")
	var clean = false

	@Option(help: "The path to the App Icon asset catalog (*.xcassets directory), will use current directly if not specified")
	var assetPath: String?
	
	@Option(help: "Badge style, alpha[Light/Dark], beta[Light/Dark], rc[Light/Dark], release[Light/Dark]")
	var badgeStyle: BadgeStyle?
	
	@Argument(help: "Main banner text")
	var mainText: String?

	@Argument(help: "Sub banner text")
	var subText: String?

	mutating func run() throws {
		
		/*
			Backup needs to occur automatically, if no back has been done before
			If backup is requested, should only backup icons if no backup exist
		
			Essentially, parse the catalog and copy each file
		*/
		
//		let source = URL(fileURLWithPath: "/Users/shanew/Development/Swann/SwannSecurity/SwannSecurityApp/SwannSecurity/Assets/Assets.xcassets/AppIcon.appiconset/App20@3x.png")
//		try Badger.badge(icon: source, withBannerText: "1.18.16", subBannerText: "2", badge: .betaDark)
		
		var usePath = FileManager.default.currentDirectoryPath
		if let path = assetPath {
			usePath = path
		}

		print("Load asset catalog \(usePath)".white)
		let assets = try AssetParser.parse(source: URL(fileURLWithPath: usePath))

		if clean {
			try Archive.removeBackups(for: assets)
		}

		if backup {
			try Archive.backup(assets: assets)
		} else if restore {
			try Archive.restore(assets: assets)
		}

		guard let mainText = mainText, let subText = subText else {
			print("No main or sub text supplied".yellow)
			return
		}

		try Archive.backup(assets: assets)

		let fileManager = FileManager.default
		for icon in assets {
			let badgedIcon = try Badger.badge(icon: icon, withBannerText: mainText, subBannerText: subText, badge: badgeStyle ?? .none)
			try fileManager.removeItem(at: icon)
			//print(badgedIcon.pixelSize)
			print("Write badged icon to".lightWhite, "\(icon)".white)
			try badgedIcon.pngWrite(to: icon)
			//print("")
		}
	}
}

let arguments = CommandLine.arguments.dropFirst().compactMap { $0 }
if arguments.first == "generate" {
	print()
	AlphaBadge.generate()
	BetaBadge.generate()
	ReleaseCandidateBadge.generate()
	ReleaseBadge.generate()
} else {
	BadgeIt.main()
}
