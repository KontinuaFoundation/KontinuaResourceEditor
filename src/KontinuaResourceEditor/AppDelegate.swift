//
//  AppDelegate.swift
//  KontinuaResourceEditor
//
//  Created by Aaron Hillegass on 10/18/23.
//

import Cocoa
import os

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // All the topic ids
    public var topicList:[String]
    // The details about each topic
    public var topicDict:[String:Topic]
    
    var prefsController:PrefsController = PrefsController()
    

    override init() {
        self.topicDict = [:]
        self.topicList = []
    }
    
    func updateTopicsList() {
        let defaults = UserDefaults()
        // The user can have the latest topic_index
        var path = defaults.value(forKeyPath: PrefsController.pathKey) as? String
        
        // Or use the one in the app wrapper
        if path == nil {
            path = Bundle.main.path(forResource:"topic_index", ofType: "json")
        }
           
        do {
            let url = URL(fileURLWithPath: path!)
            guard url.startAccessingSecurityScopedResource() else {
                os_log("No permission to read: \(url)")
                return
            }
            let jsonData = try Data(contentsOf:url)
            url.stopAccessingSecurityScopedResource()
            let decoder = JSONDecoder()
            topicDict = try decoder.decode([String:Topic].self, from: jsonData)
            topicList = Array(topicDict.keys)
            os_log("Topics read: \(self.topicList.count)")
        } catch {
            os_log("Parsing error: \(error)")
        }
    }
  
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.updateTopicsList()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
        return false
    }
    
    // Bring the Preferences Panel on screen
    @IBAction func showPrefs(_ sender:Any) {
        prefsController.showWindow(nil)
    }
}

