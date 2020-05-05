//
//  RecorderService.swift
//  AlarmTest
//
//  Created by Dmitriy Zakharov on 03.05.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import Foundation
import AVFoundation


class RecorderService: NSObject, AVAudioRecorderDelegate  {
    private var audioRecorder: AVAudioRecorder?
    private var audioSession = AVAudioSession.sharedInstance()
    
    override init() {
        super.init()
        self.registerForNotifications()
    }
    
    /// Start recording service
    public func startRecording(name: String) {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("\(name).m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            try initRecordSession()
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.prepareToRecord()
            audioRecorder?.delegate = self
            audioRecorder?.record()
        } catch {
            finishRecording()
        }
    }
    
    public func resumeRecord() {
        audioRecorder?.record()
    }
    
    public func pauseRecord() {
        audioRecorder?.pause()
    }
    
    public func finishRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
    }
    
    /// Init record session
    private func initRecordSession() throws {
        try audioSession.setCategory(.record, mode: .default, options: .mixWithOthers)
        try audioSession.setActive(true)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    /// Register Interruption notification
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleInterruption),
                                               name: AVAudioSession.interruptionNotification,
                                               object: AVAudioSession.sharedInstance())
    }
    
    /// Handle Interruption for record
    @objc func handleInterruption(_ notification: Notification) {
        guard let info = notification.userInfo,
            let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
        }
        
        if type == .ended {
            guard let optionsValue = info[AVAudioSessionInterruptionOptionKey] as? UInt else {
                return
            }
            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
            if options.contains(.shouldResume) {
               self.resumeRecord()
            }
        }
    }
}


