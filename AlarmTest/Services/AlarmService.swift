//
//  AlarmService.swift
//  AlarmTest
//
//  Created by Dmitriy Zakharov on 03.05.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox
import UIKit

enum AlarmState: String {
    case idle
    case playing
    case pause
    case recording
    case alarm
}

class AlarmService: AlarmServiceProtocol {
    private let alarmStateKey = "alarm_state"
    private let alarmSongName = "alarm.mp3"
    private let sleepSongName = "nature.mp3"
    
    private let player = PlayerService()
    private let recorder = RecorderService()
    
    private var alarmWorkItem: DispatchWorkItem?
    private var sleepWorkItem: DispatchWorkItem?
    private var alarmQueue = DispatchQueue.global(qos: .background)
    
    public var alarmServiceDelegate: AlarmServiceDelegate?
    
    public var currentState = AlarmState.idle {
        didSet {
            DispatchQueue.main.async {
                self.alarmServiceDelegate?.changeState()
            }
        }
    }

    init() {}
    
    /// Init Alarm and request permission
    public func setAlarm(time: Date, sleep: Int = 0, success: @escaping (Bool) -> ()) {
        AVAudioSession.sharedInstance().requestRecordPermission() { [weak self] allowed in
            if allowed {
                success(true)
                self?.startAlarmSession(time: time, sleep: sleep)
            } else {
                success(false)
            }
        }
    }
    
    /// Play pause sleep timer song
    public func playePauseSong(isPlay: Bool) {
        if currentState == .alarm {
            return
        }
        isPlay ? player.playSong() : player.pauseSong()
        currentState = isPlay ? .playing : .pause
    }
    
    /// Stop if alarm is start
    public func stopAlarm() {
        self.player.stopSong(queue: alarmQueue, isFade: false, finish: {
            self.currentState = .idle
        })
    }
    
    /// Init Alarm
    private func startAlarmSession(time: Date, sleep: Int) {
        alarmQueue = DispatchQueue.global(qos: .background)
        self.initAlarmQueue(time: time)
        
        if sleep > 0 {
            self.startSleep()
            initSleepQueue(sleep, time: time)
        } else {
            self.startRecord(time: time)
        }
    }
    
    /// Run sleep timer song
    private func startSleep() {
        self.currentState = .playing
        self.player.startSong(songName: self.sleepSongName)
    }
    
    /// Start record service
    private func startRecord(time: Date) {
        self.currentState = .recording
        let recordName = self.dateToString(date: time)
        self.recorder.startRecording(name: recordName)
    }
    
    /// check if song playing and start alarm service
    private func startAlarm() {
        scheduleNotification()
        
        if let sleepWorkItem = sleepWorkItem, currentState != .alarm {
            self.player.stopSong(queue: alarmQueue, isFade: false, finish: { [weak self] in
                self?.startAlarmService()
            })
            sleepWorkItem.cancel()
        } else {
            self.startAlarmService()
        }
    }
    
    /// Stop record service and start alarm service
    private func startAlarmService() {
        self.currentState = .alarm
        self.recorder.finishRecording()
        self.player.startSong(songName: self.alarmSongName)
    }
    
    /// Init alarm queue
    private func initAlarmQueue(time: Date) {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: time)
        let date = calendar.date(from: dateComponents)!
        let interval = date.timeIntervalSinceNow > 0 ? date.timeIntervalSinceNow : 24 * 60 * 60 + date.timeIntervalSinceNow

        alarmWorkItem = DispatchWorkItem(qos: .background, flags: .barrier, block: { [unowned self] in
            self.startAlarm()
        })
        
        guard let alarmWorkItem = alarmWorkItem else {
            return
        }
        alarmQueue.asyncAfter(deadline: .now() + interval, execute: alarmWorkItem)
    }
    
    /// init background queue for sleep timer
    private func initSleepQueue(_ sleep: Int, time: Date) {
        let secondsPerMinute = 60
        
        sleepWorkItem = DispatchWorkItem(qos: .background, flags: .barrier, block: { [unowned self] in
            self.player.stopSong(queue: self.alarmQueue, isFade: true, finish: {
                self.startRecord(time: time)
            })
        })
        
        guard let sleepWorkItem = sleepWorkItem else {
            return
        }
        alarmQueue.asyncAfter(deadline: .now() + .seconds(sleep * secondsPerMinute), execute: sleepWorkItem)
    }
    
    /// send local notification
    func scheduleNotification() {
        let alarmMessage = "Wake up"
        
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = alarmMessage
        content.body = alarmMessage
        content.sound = UNNotificationSound.default
        let identifier = alarmMessage
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        notificationCenter.add(request)
    }
    
    /// Convert date to string 
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.string(from: date)
    }
}
