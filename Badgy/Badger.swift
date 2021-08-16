//
//  Badger.swift
//  BadgeIt
//
//  Created by Shane Whitehead on 11/8/20.
//  Copyright © 2020 Swann Security. All rights reserved.
//

import Foundation
import AppKit
import ArgumentParser

enum BadgeStyle: String, Codable, ExpressibleByArgument {
	case alphaLight = "alphaLight"
	case alphaDark = "alphaDark"
	case betaLight = "betaLight"
	case betaDark = "betaDark"
	case rcLight = "rcLight"
	case rcDark = "rcDark"
	case releaseLight = "releaseLight"
	case releaseDark = "releaseDark"
	case none = "none"
}

class Badger {
	
	enum Error: Swift.Error {
		case unsupportedFormat(size: CGFloat)
		case imageCreationFailed
		case failedToLoadIcon(from: URL)
		case backupDoesNotExists(for: URL)
		case unableToDeterminePixelSie(ofImage: URL)
	}

	static let darkGrayColor = CGColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1.0)
	static let orangeColor = CGColor(red: 0.996, green: 0.490, blue: 0.216, alpha: 1.0)

	static let fontSize: [CGFloat: CGFloat] = [
		20: 3,
		40: 6,
		60: 8,
		29: 4,
		58: 8,
		76: 10,
		80: 12,
		87: 14,
		120: 18,
		152: 22,
		167: 22,
		180: 26,
		1024: 160
	]

	static func badge(icon: URL, withBannerText bannerText: String, subBannerText: String, badge: BadgeStyle) throws -> NSImage {
		// Load the icon from the back, which should be the original, so it should be clean
		let backup = icon.backup
		guard backup.exists else { throw Error.backupDoesNotExists(for: backup)  }
		
		print("Loading icon asset from \(backup)".debug)
		guard let image = NSImage(contentsOf: backup) else { throw Error.failedToLoadIcon(from: backup) }
		guard let pixelSize = image.pixelSize else { throw Error.unableToDeterminePixelSie(ofImage: backup) }
		
		let sizeToUse = pixelSize
//		print("image = \(image.size)")
//		print("pixelSize = \(pixelSize)")
//		print("sizeToUse = \(sizeToUse)")

		// Quick guide to the image size
		let bounds = CGRect(x: 0, y: 0, width: sizeToUse.width, height: sizeToUse.height)
		
//		print("Asset bounds = \(pixelSize.width)x\(pixelSize.height)".debug)
		guard let textFontSize = fontSize[sizeToUse.width] else { throw Error.unsupportedFormat(size: bounds.width) }

		// Use a third of the image for the banner - should allow the text to drop
		// low enough to be excluded from the app icons frame
		let bannerSize = bounds.height / 3.0

		// Quick guides for the main and sub banner areas
		let bannerBounds = CGRect(x: 0, y: bounds.height - bannerSize, width: bounds.width - bannerSize, height: bannerSize)
		let subBannerBounds = CGRect(x: bounds.width - bannerSize, y: bounds.height - bannerSize, width: bannerSize, height: bannerSize)
		
		// Graphics context
		let context = CGContext(data: nil,
														width: Int(bounds.width),
														height: Int(bounds.height),
														bitsPerComponent: 8,
														bytesPerRow: 4 * Int(bounds.width),
														space: CGColorSpaceCreateDeviceRGB(),
														bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)!

		// Draw the original image
		context.draw(image.cgImage!, in: bounds)

		switch badge {
		case .alphaDark: context.draw(AlphaBadge.dark.cgImage!, in: bounds)
		case .alphaLight: context.draw(AlphaBadge.light.cgImage!, in: bounds)
		case .betaDark: context.draw(BetaBadge.dark.cgImage!, in: bounds)
		case .betaLight: context.draw(BetaBadge.light.cgImage!, in: bounds)
		case .none: break
		case .rcLight: context.draw(ReleaseCandidateBadge.light.cgImage!, in: bounds)
		case .rcDark: context.draw(ReleaseCandidateBadge.dark.cgImage!, in: bounds)
		case .releaseLight: context.draw(ReleaseBadge.light.cgImage!, in: bounds)
		case .releaseDark: context.draw(ReleaseBadge.dark.cgImage!, in: bounds)
		}
		
		// Main banner area
		//context.beginPath()
		context.addRect(bannerBounds)
		context.setFillColor(darkGrayColor)
		context.fillPath(using: .winding)
		//context.closePath()

		// Sub banner area
		//context.beginPath()
		context.addRect(subBannerBounds)
		context.setFillColor(orangeColor)
		context.fillPath(using: .winding)
		//context.closePath()

//		// MARK: - Guide
//
//		let radius = bounds.size.width / 5
//		let appIconPath = CGPath(roundedRect: bounds, cornerWidth: radius, cornerHeight: radius, transform: nil)
//
////		context.beginPath()
//		context.addPath(appIconPath)
//		context.setStrokeColor(CGColor(red: 1, green: 0, blue: 0, alpha: 1))
//		context.strokePath()
////		context.closePath()
//
//		// MARK: Guide -
//
		guard let cgImage = context.makeImage() else { throw Error.imageCreationFailed }

		let scale: CGFloat = NSScreen.main?.backingScaleFactor ?? 1
		let targetSize = CGSize(width: CGFloat(cgImage.width) / scale, height: CGFloat(cgImage.height) / scale)

		// Create the base image
		let badgedImage = NSImage(cgImage: cgImage, size: CGSize(width: cgImage.width, height: cgImage.height))

		// Prepare for text rendering
		badgedImage.lockFocus()

		// Main banner text properties
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .center

		let font = NSFont.systemFont(ofSize: textFontSize)

		//let bannerText = "1.18.16"
		let bannerAttribtes: [NSAttributedString.Key: Any] = [
			NSAttributedString.Key.font: font,
			NSAttributedString.Key.paragraphStyle: paragraphStyle,
			NSAttributedString.Key.foregroundColor: NSColor.white,
		]

		// Sub banner text properties
		//let subBannerText = "2"
		let subBannerAttribtes: [NSAttributedString.Key: Any] = [
			NSAttributedString.Key.font: font,
			NSAttributedString.Key.paragraphStyle: paragraphStyle,
			NSAttributedString.Key.foregroundColor: NSColor.white,
		]

		// Draw the text
		draw(text: bannerText, in: bannerBounds, using: bannerAttribtes)
		draw(text: subBannerText, in: subBannerBounds, using: subBannerAttribtes)

		badgedImage.unlockFocus()

		//let badgeSize = badgedImage.pixelSize
//		print("bagded image = \(badgeSize)/\(badgedImage.size)".debug)

		// For testing...
//		let homeURL = FileManager.default.homeDirectoryForCurrentUser
//		let badgedURL = homeURL.appendingPathComponent("Badged@\(bounds.width).png")
//		try badgedImage.pngWrite(to: badgedURL, options: .atomic)

		return badgedImage.resize(to: targetSize)!
	}
	
	// Draw the text centered within the specified bounds
	static func draw(text: String, in bounds: CGRect, using attributes: [NSAttributedString.Key: Any]) {
		let nsString = text as NSString
		let textSize = nsString.size(withAttributes: attributes)
		let xPos = bounds.origin.x + ((bounds.width - textSize.width) / 2)
		let yPos = bounds.origin.y + ((bounds.height - textSize.height) / 2)

		nsString.draw(at: NSPoint(x: xPos, y: yPos), withAttributes: attributes)
	}
}
