//
//  ViewController.swift
//  Localizator
//
//  Created by Yangfan Huang on 7/26/15.
//  Copyright © 2015 Zepp Inc. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate {
	@IBOutlet weak var jsonRoot: NSTextField!
	@IBOutlet weak var projectRoot: NSTextField!
	@IBOutlet weak var stringsRoot: NSTextField!
	
	@IBOutlet weak var jsonButton: NSButton!
	@IBOutlet weak var stringsButton: NSButton!
	@IBOutlet weak var projectButton: NSButton!

	@IBOutlet weak var searchField: NSSearchField!
	@IBOutlet var console: NSTextView!
	
	@IBOutlet weak var goButton: NSButton!
	
	var localizator:Localizator = Localizator()
	var processing = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	func browseDirectory(hint:String?, completion:(NSURL -> Void)) {
		let panel = NSOpenPanel()
		panel.allowsMultipleSelection = false
		panel.canChooseDirectories = true
		panel.canChooseFiles = false
		if hint != nil {
			panel.directoryURL = NSURL(string: hint!)
		}
		
		panel.beginSheetModalForWindow(NSApplication.sharedApplication().windows[0]) { button in
			if button == NSFileHandlingPanelOKButton {
				if let url = panel.URL {
					completion(url)
				}
			}
		}
	}
	
	func checkGoButton() {
		self.goButton.enabled = !self.localizator.translations.isEmpty
			&& (!self.localizator.stringsFiles.isEmpty || !self.localizator.storyboards.isEmpty)
	}
	
	func logOnMainThread(string:String) {
		self.console.string = self.console.string?.stringByAppendingString("\(string)\n")
		self.console.scrollToEndOfDocument(nil)
		print(string)
	}
	
	func log(string:String) {
		if NSThread.isMainThread() {
			self.logOnMainThread(string)
		} else {
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				self.logOnMainThread(string)
			})
		}
	}
	
	@IBAction func browseJsonRoot(sender: AnyObject) {
		self.browseDirectory(NSUserDefaults.standardUserDefaults().stringForKey("JsonRoot")) { url in
			self.log("Reading json files in \(url.absoluteString) ...")
			self.processing = true
			self.localizator.parseTranslations(url, log: self.log) { success in
				if success {
					self.jsonRoot.stringValue = url.absoluteString
				}
				self.log("")
				self.checkGoButton()
				NSUserDefaults.standardUserDefaults().setValue(url.absoluteString, forKey: "JsonRoot")
				self.processing = false
			}
		}
	}
	
	@IBAction func browseProjectRoot(sender: AnyObject) {
		self.browseDirectory(NSUserDefaults.standardUserDefaults().stringForKey("ProjectRoot")) { url in
			self.log("Searching storyboard templates in \(url.absoluteString) ...")
			self.processing = true
			self.localizator.findStoryboards(url, log: self.log) { success in
				if success {
					self.projectRoot.stringValue = url.absoluteString
				}
				self.log("")
				self.checkGoButton()
				NSUserDefaults.standardUserDefaults().setValue(url.absoluteString, forKey: "ProjectRoot")
				self.processing = false
			}
		}
	}
	
	@IBAction func browseStringsRoot(sender: AnyObject) {
		browseDirectory(NSUserDefaults.standardUserDefaults().stringForKey("StringsRoot")) { url in
			self.log("Reading strings file in \(url.absoluteString) ...")
			self.processing = true
			self.localizator.findStrings(url, log: self.log) { success in
				if success {
					self.stringsRoot.stringValue = url.absoluteString
				}
				self.log("")
				self.checkGoButton()
				NSUserDefaults.standardUserDefaults().setValue(url.absoluteString, forKey: "StringsRoot")
				self.processing = false
			}
		}
	}
	
	
	@IBAction func translate(sender: AnyObject) {
		self.processing = true
		self.localizator.translate(self.log) { success in
			self.log("\nDone\n")
			self.processing = false
		}
	}
	
	@IBAction func openSearch(sender: AnyObject) {
		self.searchField.becomeFirstResponder()
	}
	
	@IBAction func searchKey(sender: AnyObject) {
		let key = self.searchField.stringValue
		
		if !key.isEmpty && !self.processing && !self.localizator.translations.isEmpty {
			log("Searching key \(key) ...")
			var count = 0
			for (language, translation) in self.localizator.translations {
				let value = translation[key]
				
				if value != nil {
					log("\(language): \(value!)")
					count++
				}
			}
			log("\(count) results found\n")
		}
	}
	
	@IBAction func newDocument(sender: AnyObject) {
		self.jsonRoot.stringValue = ""
		self.projectRoot.stringValue = ""
		self.stringsRoot.stringValue = ""
		self.console.string = ""
		
		self.localizator = Localizator()
		
		self.checkGoButton()
	}
	
	@IBAction func performClose(sender: AnyObject) {
		self.newDocument(sender)
	}
	
	override func validateMenuItem(menuItem: NSMenuItem) -> Bool {
		if self.processing {
			return false
		}
		
		if menuItem.action == "translate:" {
			return !self.localizator.translations.isEmpty
				&& (!self.localizator.stringsFiles.isEmpty || !self.localizator.storyboards.isEmpty)
		}
		
		return true
	}
}

