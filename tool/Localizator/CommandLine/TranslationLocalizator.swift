//
//  Translation.swift
//  Localizator
//
//  Created by Binea Xu on 9/15/15.
//  Copyright © 2015 Zepp Inc. All rights reserved.
//

import Foundation

class TranslationLocalizator{
    
    static let semaphore = dispatch_semaphore_create(0)
    
    class func translate(jsonDirectory: String, stringsDirectory: String, projectDirectory: String){
        let localizator:Localizator = Localizator()
        localizator.queue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
        
        //json
        let jsonUrl = NSURL(fileURLWithPath: jsonDirectory)
        localizator.parseTranslations(jsonUrl, log: self.log){
            success in
            if success {
            
                //string directory
                let stringsUrl = NSURL(fileURLWithPath: stringsDirectory)
                localizator.findStrings(stringsUrl, log: self.log){ success in
                    if success {
                        
                        //project directory
                        let projectUrl = NSURL(fileURLWithPath: projectDirectory)
                        localizator.findStoryboards(projectUrl, log: self.log){ success in
                            if success {
                                localizator.translate(self.log) { success in
                                    self.log("\nDone\n")
                                    dispatch_semaphore_signal(semaphore)
                                }
                            } else {
                                dispatch_semaphore_signal(semaphore)
                            }
                            self.log("")
                        }
                    } else {
                        dispatch_semaphore_signal(semaphore)
                    }
                    self.log("")
                    
                }
            } else {
                dispatch_semaphore_signal(semaphore)
            }
            self.log("jsonRoot")

        }
    }
    
    class func log(string:String) {
        print(string)
    }
    
    class func main() {
        var i = 0
        
        var jsonRoot: String = ""
        var stringsRoot: String = ""
        var projectRoot: String = ""
        
        for argument in Process.arguments {
            switch argument {
            case "-j":
                if i+1 > Process.arguments.count - 1{
                    log("must input json directory")
                    break
                }
                jsonRoot = Process.arguments[i + 1]
            case "-l":
                if i+1 > Process.arguments.count - 1{
                    log("must input strings directory")
                    break
                }
                stringsRoot = Process.arguments[i + 1]
            case "-p":
                if i+1 > Process.arguments.count - 1{
                    log("must input project directory")
                    break
                }
                projectRoot = Process.arguments[i + 1]
                
            default:
                log("nothing")
            }
            ++i
        }
        
        if (!jsonRoot.isEmpty && (!stringsRoot.isEmpty || !projectRoot.isEmpty)) {
            translate(jsonRoot, stringsDirectory: stringsRoot, projectDirectory: projectRoot)
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
            log("success")
        }

    }
}