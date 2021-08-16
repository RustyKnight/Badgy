//
//  CandidateBadge.swift
//  BadgeIt
//
//  Created by Shane Whitehead on 11/8/20.
//  Copyright © 2020 Swann Security. All rights reserved.
//

import Foundation
import AppKit

struct ReleaseCandidateBadge {

	//beta_badge_dark.png
	fileprivate static let betaDark = "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NzaXXXaZWbRoUanxffjhh+b66683H3/8can6PlWKy6txzfFpcIwlfAJty7vddtuZm2++2Rx44IGl4X3//ffmq6++Kl3fl4rj8mpcHIF9iU4PxtG2vDry3n333Wa//fYrTe/VV18111xzjfn9999Lt/GhYpa8GhdHYB+i04MxtC2vkF1xxRUpeacS3TzxxBNm9erV5pNPPjHbbrutOe2008zJJ59s3nnnnV7JKwYcgUWBpRGBLuQ98cQTzbXXXpsY96effmpuvfVW88YbbyTKtaJvpv/666/eHHmjCXIEjkjwWotAF/JqoOecc05ivD/99JO56qqrzOeff54oj1Z+/vnn6G3u62abbWZ+++233O1tb8g7bY6PY3Z8hfcQqEKgK3kPPfRQs88++ySGunLlylx5ExVzVo466ihz7733Gknsw1JGXo0TgX2IVoBj6EpeoZo/f36CmD73Pv3004myKiuS98YbbzS77rqrueCCC6o0dVK3rLzaOQI7CUG/O+1SXpHV3VXxRafH3377bbyo9PtI3k022WTUZvHixWbzzTcv3d52xSryat8IbDsCPe+va3mFd8cdd0xQ1hdUW221VaKs7MrFF19sInnVRu8ldRdLVXk1RgTuIlKB7tMHeYVO3ybHF902ecABB8SLSr9/6qmnUnUPOeSQVJnrgjryakwI7DoyPenfF3mF87333ktRPeKII1JlZQqefPLJVLW2v8iqK68GjsCp8FEwTsAneTW2LIGXLl2a+mw8Po+s9b///jtVvNFGG6XKXBU0kVdjQmBXkelJv77JK6wvvPBC6nqtPrteeeWVZvbsaim9ww47pCL1wQcfpMpcFDSVV2OqNlsXs6BPbwl0Ia8+z+6+++6jS0U6Ld5+++1TfH744Qfz2GOPpcqPPPJIc8kll6TKiwqOPvro1Oa33norVWa7wIa8GhN3YtmOTE/6a1tefZN81llnjf7i3yjrFPfFF180999/v4kfGR966CFz+umnm0033TRB/MwzzzRTD7qbFStWTHx4X9d9zz///ER7PWr49ttvJ8psr9iSV+Nq72TfNgX6c0agbXkPOuggc9ddd5ljjjkmcUlHE9Qp8R577GFOPfVU88UXX8xI/Ouvv5ovv/wydVOH2ujRQj3c/9prrxnVy1q22Wab0c0bu+yyS2LznXfeaSSxq8WmvBojAruKVKD9ti2v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"
	//beta_badge_light.png
	fileprivate static let betaLight = "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"

	static var dark: NSImage = {
		let data = Data(base64Encoded: betaDark)!
		return NSImage(data: data)!
	}()
	
	static var light: NSImage = {
		let data = Data(base64Encoded: betaLight)!
		return NSImage(data: data)!
	}()
	
	static func generate() {
		do {
			let text = try AssetGenerator.generate(from: "CandidateDark.png")
			print("Candidate, dark".bold.lightWhite)
			print(text.white)
		} catch let error {
			print("Failed to generate dark Candidate asset".lightRed)
			print("\(error)".red)
		}
		print("")
		do {
			let text = try AssetGenerator.generate(from: "CandidateLight.png")
			print("Candidate, light".bold.lightWhite)
			print(text.white)
		} catch let error {
			print("Failed to generate light Candidate asset".lightRed)
			print("\(error)".red)
		}
		print("")
	}


}