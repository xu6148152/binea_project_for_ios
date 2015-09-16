//
//  Localizator.swift
//  Localizator
//
//  Created by Yangfan Huang on 7/26/15.
//  Copyright © 2015 Zepp Inc. All rights reserved.
//

import Foundation

class Localizator {
	static var localeMap = [
		"en"	: "en",
		"uk"	: "en-GB",
		"de"	: "de",
		"es"	: "es",
		"fr"	: "fr",
		"it"	: "it",
		"ja"	: "ja",
		"ko"	: "ko",
		"hans"	: "zh-Hans",
		"hant"	: "zh-Hant"
	]
	
	static var usingBase = [
		"en-GB", "en"
	]
    
    var queue:dispatch_queue_t?
	
	var translations:[String:[String:String]] = [:]
	
	var stringsRoot:NSURL?
	var stringsFiles:[NSURL] = []
	
	var storyboards:[NSURL] = []
	
    func callbackQueue() -> dispatch_queue_t {
        return self.queue == nil ? dispatch_get_main_queue() : self.queue!
    }
    
	func parseTranslations(url:NSURL, log:(String -> Void), completion:(Bool->Void)) {
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
			self.translations.removeAll()
			
			do {
				var subURLs = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(url,
					includingPropertiesForKeys: [NSURLIsDirectoryKey],
					options: NSDirectoryEnumerationOptions.SkipsHiddenFiles)
				
				subURLs = subURLs.filter( { subURL in
					var isDirectory:AnyObject?
					do {
						try subURL.getResourceValue(&isDirectory, forKey:NSURLIsDirectoryKey)
						return (isDirectory! as! NSNumber).boolValue && Localizator.localeMap[subURL.lastPathComponent!.lowercaseString] != nil
					} catch {
						return false
					}
				})
				
				if subURLs.count == 0 {
					log("No sub directories, use selected directory for en")
					let result = self.parseJSONDirectory(url, log: log)
					
					if result != nil && result!.count > 0 {
						log("\(result!.count) keys found for en")
						self.translations["en"] = result!
					} else {
						log("No keys found for en")
					}
				} else {
					for subURL in subURLs {
						let language = Localizator.localeMap[subURL.lastPathComponent!.lowercaseString]!
						
						log("Path \(subURL.lastPathComponent!) found for \(language)")
						let result = self.parseJSONDirectory(subURL, log: log)
						
						if result != nil && result!.count > 0 {
							log("\(result!.count) keys found for \(language)")
							self.translations[language] = result!
						} else {
							log("No keys found for \(language)")
						}
					}
				}
			} catch let error {
				log("\(error)")
			}
			
			dispatch_async(self.callbackQueue(), { () -> Void in
				completion(self.translations.count > 0)
			})
		}
	}
	
	private func baseLanguage() -> String {
		for base in Localizator.usingBase {
			if self.translations[base] != nil {
				return base
			}
		}
		
		return "en"
	}
	
	private func parseJSONDirectory(jsonDir:NSURL, log:(String -> Void)) -> [String:String]? {
		let jsonFiles = self.findFilesInDirectoryURL(jsonDir, pathExtension: "json", log: log)
		if jsonFiles == nil {
			log("Error for json directory \(jsonDir.lastPathComponent)")
			return nil
		}
		
		var result:[String:String] = [:]
		
		for jsonFile in jsonFiles! {
			let entries = self.parseJSONFile(jsonFile, log:log)
			if entries != nil && entries!.count > 0 {
				for (key, value) in entries! {
					result[key] = value
				}
			} else {
				log("Error reading json file \(jsonDir.lastPathComponent!)/\(jsonFile.lastPathComponent!)")
			}
		}
		
		return result
	}
	
	private func parseJSONFile(jsonFile:NSURL,log:(String -> Void)) -> [String:String]? {
		do {
			let data = NSData(contentsOfURL: jsonFile)
			return try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? [String:String]
		} catch let error {
			log("\(error)")
			return nil
		}
	}
	
	private func findFilesInDirectoryURL(url:NSURL, pathExtension:String, log:(String -> Void)) -> [NSURL]? {
		do {
			return try NSFileManager.defaultManager().contentsOfDirectoryAtURL(url,
				includingPropertiesForKeys: [NSURLIsRegularFileKey],
				options: NSDirectoryEnumerationOptions.SkipsHiddenFiles)
				.filter({ fileURL in
					var isRegularFile:AnyObject?
					do {
						try fileURL.getResourceValue(&isRegularFile, forKey:NSURLIsRegularFileKey)
						return (isRegularFile! as! NSNumber).boolValue && fileURL.pathExtension == pathExtension
					} catch {
						return false
					}
				})
		} catch let error {
			log("\(error)")
			return nil
		}
	}
	
	func findStrings(url:NSURL, log:(String -> Void), completion:(Bool -> Void)) {
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
			self.stringsFiles.removeAll()
			
			let baseURL = NSURL(string: String(format: "%@/Base.lproj", url.absoluteString))!
			let files = self.findFilesInDirectoryURL(baseURL, pathExtension: "strings", log: log)
			if files == nil {
				log("Error in strings directory \(url.lastPathComponent)")
			} else {
				self.stringsFiles = self.stringsFiles + files!
				log("\(self.stringsFiles.count) strings files found")
				for fileURL in self.stringsFiles {
					log("\(fileURL.lastPathComponent!)")
				}
				
				self.stringsRoot = self.stringsFiles.count > 0 ? url : nil
			}
			
			dispatch_async(self.callbackQueue(), { () -> Void in
				completion(self.stringsRoot != nil)
			})
		}
	}
	
	func findStoryboards(url:NSURL, log:(String -> Void), completion:(Bool -> Void)) {
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
			self.storyboards.removeAll()
			
			let enumerator = NSFileManager.defaultManager().enumeratorAtURL(url,
				includingPropertiesForKeys: [NSURLIsRegularFileKey],
				options: NSDirectoryEnumerationOptions.SkipsHiddenFiles,
				errorHandler: nil)
			
			while let fileURL = enumerator?.nextObject() as? NSURL {
				var isRegularFile:AnyObject?
				do {
					try fileURL.getResourceValue(&isRegularFile, forKey:NSURLIsRegularFileKey)
					
					if (isRegularFile! as! NSNumber).boolValue && fileURL.lastPathComponent!.hasSuffix(".storyboard.template") {
						self.storyboards.append(fileURL)
					}
				} catch {
					log("\(error)")
				}
			}
			
			log("\(self.storyboards.count) storyboard templates found")
			for fileURL in self.storyboards {
				log(fileURL.absoluteString)
			}
			
			dispatch_async(self.callbackQueue(), { () -> Void in
				completion(!self.storyboards.isEmpty)
			})
		}
	}
	
	func translate(log:(String -> Void), completion:(Bool -> Void)) {
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
			var success = false
			
			defer {
				dispatch_async(self.callbackQueue(), { () -> Void in
					completion(success)
				})
			}
			
			guard !self.translations.isEmpty && (!self.stringsFiles.isEmpty || !self.storyboards.isEmpty) else {
				log("Nothing to translate")
				return
			}
			
			for fileURL in self.stringsFiles {
				self.translateStrings(fileURL, log: log)
			}
			
			for fileURL in self.storyboards {
				self.trasnlateStoryboard(fileURL, log:log)
			}
			
			success = true
		}
	}
	
	private func translateStrings(url:NSURL, log:(String -> Void)) {
		log("Translating strings file \(url.lastPathComponent!) ...")
		
		do {
			let keyValues = try NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding).propertyListFromStringsFileFormat()
			
			if keyValues == nil {
				log("Cannot find strings in \(url.lastPathComponent!)")
				return
			}
			
			for (language, translation) in self.translations {
				log("\nInto \(language):")
				let languageDir = url.URLByDeletingLastPathComponent?
					.URLByDeletingLastPathComponent?
					.URLByAppendingPathComponent("\(language).lproj", isDirectory: true)
				
				try NSFileManager.defaultManager().createDirectoryAtURL(languageDir!, withIntermediateDirectories: true, attributes: nil)
				
				let dict:NSMutableDictionary = [:]
				for (k, v) in keyValues! {
					let key = k as! String
					let value = translation[key]
					if value == nil {
						log("Key \"\(key)\" not found in \(language) translation")
						dict[key] = v
					} else {
						dict[key] = value!
					}
				}
				
				let languageFile = languageDir?.URLByAppendingPathComponent(url.lastPathComponent!, isDirectory: false)
				try dict.descriptionInStringsFileFormat.writeToURL(languageFile!, atomically: true, encoding: NSUTF8StringEncoding)
				
				if language == self.baseLanguage() {
					// copy back to base
					log("\nCopying \(self.baseLanguage()) to Base ...")
					try NSFileManager.defaultManager().removeItemAtURL(url)
					try NSFileManager.defaultManager().copyItemAtURL(languageFile!, toURL: url)
				}
			}
		} catch let error {
			log("\(error)")
		}
	}
	
	private func trasnlateStoryboard(url:NSURL, log:(String -> Void)) {
		log("\nTranslating storyboard strings from \(url.absoluteString) ...")
		
		do {
			let keyValues = try NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding).propertyListFromStringsFileFormat()
			
			if keyValues == nil {
				log("Cannot find strings in \(url.lastPathComponent!)")
				return
			}
			
			for (language, translation) in self.translations {
				log("Into \(language):")
				let languageDir = url.URLByDeletingLastPathComponent?.URLByAppendingPathComponent("\(language).lproj", isDirectory: true)
				
				try NSFileManager.defaultManager().createDirectoryAtURL(languageDir!, withIntermediateDirectories: true, attributes: nil)
				
				let dict:NSMutableDictionary = [:]
				for (xibKey, k) in keyValues! {
					let key = k as! String
					let value = translation[key]
					if value == nil {
						if key.hasPrefix("str_") {
							log("Key \"\(key)\" not found in \(language) translation")
						}
						dict[xibKey as! String] = k
					} else {
						dict[xibKey as! String] = value!
					}
				}
				
				let languageFile = languageDir?.URLByAppendingPathComponent(
					url.URLByDeletingPathExtension!
						.URLByDeletingPathExtension!
						.URLByAppendingPathExtension("strings")
						.lastPathComponent!,
					isDirectory: false)
				try dict.descriptionInStringsFileFormat.writeToURL(languageFile!, atomically: true, encoding: NSUTF8StringEncoding)
				
				if language == self.baseLanguage() {
					log("Translating base storyboard \(url.URLByDeletingPathExtension!.lastPathComponent!) using \(self.baseLanguage()) ...")
					
					let storyboardFile = url.URLByDeletingLastPathComponent?
						.URLByAppendingPathComponent("Base.lproj", isDirectory: true)
						.URLByAppendingPathComponent(url.URLByDeletingPathExtension!.lastPathComponent!, isDirectory: false)
					
					let doc = try NSXMLDocument(contentsOfURL: storyboardFile!, options: 0)
					for (xibKey, k) in keyValues! {
						let key = k as! String
						let value = translation[key]
						
						if value != nil {
							let xibString = xibKey as! String
							let dotRange = xibString.rangeOfString(".")
							if dotRange == nil || dotRange!.endIndex == xibString.endIndex {
								log("Can't find element id from \(xibString)")
								continue
							}
							
							let elementId = xibString.substringToIndex(dotRange!.startIndex)
							let elementAttr = xibString.substringFromIndex(dotRange!.endIndex)
							
							let elements = try doc.rootElement()?.nodesForXPath("//*[@id='\(elementId)']")
							if elements == nil || elements!.isEmpty {
								log("Can't find xml element id \(elementId)")
								continue
							}
							
							var element:NSXMLElement? = nil
							for e in elements! {
								if e.kind == NSXMLNodeKind.ElementKind {
									element = e as? NSXMLElement
									break
								}
							}
							
							if elementAttr == "normalTitle" {
								let states = try element?.nodesForXPath("./state[@key='normal']")
								if states == nil || states!.isEmpty {
									log("Can't find normal state for button id \(elementId)")
									continue
								}
								
								var state:NSXMLElement? = nil
								for s in states! {
									if s.kind == NSXMLNodeKind.ElementKind {
										state = s as? NSXMLElement
										break
									}
								}
								
								state?.addAttribute(NSXMLNode.attributeWithName("title", stringValue: value!) as! NSXMLNode)
							} else {
								element?.addAttribute(NSXMLNode.attributeWithName(elementAttr, stringValue: value!) as! NSXMLNode)
							}
						}
					}
					doc.XMLDataWithOptions(NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement).writeToURL(storyboardFile!, atomically: true)
				}
			}
		} catch let error {
			log("\(error)")
		}
	}
}
