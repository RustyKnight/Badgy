//
//  NSImage+Scale.swift
//  BadgeIt
//
//  Created by Shane Whitehead on 11/8/20.
//  Copyright © 2020 Swann Security. All rights reserved.
//

import Foundation
import AppKit

extension NSImage {
	
	func scale(by scale: CGFloat) -> NSImage? {
		let width = self.size.width * scale
		let height = self.size.height * scale
		
		return resize(to: NSSize(width: width, height: height))
	}
	
	func resize(to size: NSSize) -> NSImage? {
		// Create a new rect with given width and height
		let frame = NSMakeRect(0, 0, size.width, size.height)
		
		// Get the best representation for the given size.
		guard let rep = self.bestRepresentation(for: frame, context: nil, hints: nil) else {
			return nil
		}
		
		// Create an empty image with the given size.
		let img = NSImage(size: size)
		
		// Set the drawing context and make sure to remove the focus before returning.
		img.lockFocus()
		defer { img.unlockFocus() }
		
		if rep.draw(in: frame) {
			return img
		}
		
		// Return nil in case something went wrong.
		return nil
	}
	
}
