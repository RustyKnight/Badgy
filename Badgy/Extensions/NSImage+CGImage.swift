//
//  NSImage+CGImage.swift
//  BadgeIt
//
//  Created by Shane Whitehead on 11/8/20.
//  Copyright © 2020 Swann Security. All rights reserved.
//

import Foundation
import AppKit

extension NSImage {
	
	var cgImage: CGImage? {
		var rect = CGRect.init(origin: .zero, size: self.size)
		return self.cgImage(forProposedRect: &rect, context: nil, hints: nil)
	}
	
}
