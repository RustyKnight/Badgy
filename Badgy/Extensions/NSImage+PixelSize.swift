//
//  NSImage+PixelSize.swift
//  BadgeIt
//
//  Created by Shane Whitehead on 11/8/20.
//  Copyright © 2020 Swann Security. All rights reserved.
//

import Foundation
import AppKit

extension NSImage {
	
	var pixelSize: CGSize? {
		return representations.reduce(CGSize.zero, { (size: CGSize, rep: NSImageRep) -> CGSize in
			return CGSize(width: max(size.width, CGFloat(rep.pixelsWide)), height: max(size.height, CGFloat(rep.pixelsHigh)))
		})
	}
	
//	func sizeForImageAtURL(url: NSURL) -> CGSize? {
//			guard let imageReps = NSBitmapImageRep.imageRepsWithContentsOfURL(url) else { return nil }
//			return imageReps.reduce(CGSize.zero, combine: { (size: CGSize, rep: NSImageRep) -> CGSize in
//					return CGSize(width: max(size.width, CGFloat(rep.pixelsWide)), height: max(size.height, CGFloat(rep.pixelsHigh)))
//			})
//	}
}
