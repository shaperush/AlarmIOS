//
//  AppDelegate.swift
//  AlarmTest
//
//  Created by Dmitriy Zakharov on 03.05.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    let alarmService: AlarmServiceProtocol = AlarmService()
    let notifCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        requestAuthForLocalNotifications()
        return true
    }
    
    func requestAuthForLocalNotifications() {
        notifCenter.delegate = self
        notifCenter.requestAuthorization(options: [.alert, .sound, .provisional]) { (granted, error) in
            if error != nil {
                
            }
        }
    }
}

