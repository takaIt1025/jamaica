//
//  jamaicaApp.swift
//  Shared
//
//  Created by Takaya Ito on 2023/04/08.
//

import SwiftUI
import UIKit
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Mobile Ads SDKを初期化する
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
}


@main
struct jamaicaApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
