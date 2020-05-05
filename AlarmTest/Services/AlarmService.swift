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
    private var alarmQueue: DispatchQueue?
    
    public var alarmServiceDelegate: AlarmServiceDelegate?
    
    public var currentState : AlarmState {
        get {
            guard let state = UserDefaults.standard.value(forKey: alarmStateKey) as? String else {
                UserDefaults.standard.set(AlarmState.idle.rawValue, forKey: alarmStateKey)
                return AlarmState.idle
            }
            return AlarmState(rawValue: state) ?? AlarmState.idle
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: alarmStateKey)
            DispatchQueue.main.async {
                self.alarmServiceDelegate?.changeState(state: newValue)
            }
        }
    }
    
    init() {

    }
    
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
    
    public func playSong() {
        self.player.playSong()
        currentState = .playing
    }
    
    public func pauseSong() {
        self.player.pauseSong()
        currentState = .pause
    }
    
    public func stopAlarm() {
        self.player.stopSong {
            self.currentState = .idle
        }
    }
    
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
    
    private func startSleep() {
        self.currentState = .playing
        self.player.startSong(songName: self.sleepSongName)
    }
    
    private func startRecord(time: Date) {
        self.currentState = .recording
        let recordName = self.dateToString(date: time)
        self.recorder.startRecording(name: recordName)
    }
    
    private func startAlarm() {
        if let sleepWorkItem = sleepWorkItem, currentState == .playing {
            self.player.stopSong(finish: {
                self.alarmQueue?.async {
                    self.startAlarmService()
                }
            })
            sleepWorkItem.cancel()
        } else {
            self.startAlarmService()
        }
    }
    
    private func startAlarmService() {
        self.currentState = .alarm
        self.recorder.finishRecording()
        self.player.startSong(songName: self.alarmSongName)
    }
    
    private func initAlarmQueue(time: Date) {
        let interval = time.timeIntervalSinceNow
        alarmWorkItem = DispatchWorkItem(qos: .background, flags: .barrier, block: { [weak self] in
            self?.startAlarm()
        })
        
        guard let alarmWorkItem = alarmWorkItem else {
            return
        }
        alarmQueue?.asyncAfter(deadline: .now() + interval, execute: alarmWorkItem)
    }
    
    private func initSleepQueue(_ sleep: Int, time: Date) {
        let secondsPerMinute = 60
        
        sleepWorkItem = DispatchWorkItem(qos: .background, flags: .barrier, block: { [weak self] in
            self?.startRecord(time: time)
        })
        guard let sleepWorkItem = sleepWorkItem else {
            return
        }
        alarmQueue?.asyncAfter(deadline: .now() + .seconds(sleep * secondsPerMinute), execute: sleepWorkItem)
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.string(from: date)
    }
}
