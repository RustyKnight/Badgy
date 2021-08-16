//
//  URL+backup.swift
//  BadgeIt
//
//  Created by Shane Whitehead on 11/8/20.
//  Copyright © 2020 Swann Security. All rights reserved.
//

import Foundation

extension URL {
	
	var backup: URL {
		return deletingPathExtension().appendingPathExtension("org")
	}
	
	var exists: Bool {
		return FileManager.default.fileExists(atPath: path)
	}
	
}
