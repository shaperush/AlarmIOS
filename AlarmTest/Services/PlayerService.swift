//
//  PlayerService.swift
//  AlarmTest
//
//  Created by Dmitriy Zakharov on 03.05.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit


class PlayerService: NSObject, AVAudioPlayerDelegate {
    private var audioPlayer: AVAudioPlayer?
    
    override init() {
        super.init()
    }
    
    public func playSong() {
        audioPlayer?.play()
    }
      
    public func pauseSong() {
        audioPlayer?.pause()
    }
  
    public func startSong(songName: String) {
        let infinityLoopMusic = -1
        let fadeinSongSecond = 6.0
        
        guard let path = Bundle.main.path(forResource: songName, ofType: nil) else {
            return
        }
        let url = URL(fileURLWithPath: path)
        
        do {
            try initAudioSession()
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.delegate = self
            audioPlayer?.setVolume(0.0, fadeDuration: 0.0)
            audioPlayer?.numberOfLoops = infinityLoopMusic
            audioPlayer?.play()
            audioPlayer?.setVolume(1.0, fadeDuration: fadeinSongSecond)
        } catch let error as NSError {
          print("audioPlayer error \(String(describing: error.localizedDescription))")
        }
    }
  
    public func stopSong(queue: DispatchQueue, isFade: Bool, finish: @escaping () -> ()) {
        let fadeoutSongSecond = 6
        audioPlayer?.setVolume(0.0, fadeDuration: Double(fadeoutSongSecond))
        if(isFade) {
                queue.asyncAfter(deadline: .now() + .seconds(fadeoutSongSecond)) { [weak self] in
                self?.audioPlayer?.stop()
                self?.audioPlayer = nil
                finish()
            }
        } else {
            self.audioPlayer?.stop()
            self.audioPlayer = nil
            finish()
        }
    }
    
    /// Init audio session
    private func initAudioSession() throws {
        try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
        try AVAudioSession.sharedInstance().setActive(true)
    }
    
    //AVAudioPlayerDelegate protocol
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        self.pauseSong()
    }
    
    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
        self.playSong()
    }
}
