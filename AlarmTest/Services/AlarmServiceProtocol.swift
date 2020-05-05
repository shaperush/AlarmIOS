//
//  AlarmServiceProtocol.swift
//  AlarmTest
//
//  Created by Dmitriy Zakharov on 03.05.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import Foundation


protocol AlarmServiceProtocol {
    func setAlarm(time: Date, sleep: Int, success: @escaping (Bool) -> ())
}
