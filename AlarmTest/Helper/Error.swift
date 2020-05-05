//
//  Error.swift
//  AlarmTest
//
//  Created by Dmitriy Zakharov on 05.05.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import Foundation


enum AlarmError: String {
    case emptyDate = "choose alarm time"
    case microphonePermission = "need accept microphone permission"
}
