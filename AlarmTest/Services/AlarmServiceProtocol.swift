//
//  AlarmServiceProtocol.swift
//  AlarmTest
//
//  Created by Dmitriy Zakharov on 03.05.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import Foundation


protocol AlarmServiceProtocol: class {
    var alarmServiceDelegate: AlarmServiceDelegate? { get set }
    var currentState : AlarmState { get }
    
    func setAlarm(time: Date, sleep: Int, success: @escaping (Bool) -> ())
    func playePauseSong(isPlay: Bool)
    func stopAlarm() 
}

protocol AlarmServiceDelegate: class {
    func changeState()
}
