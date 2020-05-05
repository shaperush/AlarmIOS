//
//  MainProtocol.swift
//  AlarmTest
//
//  Created by Dmitriy Zakharov on 03.05.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import Foundation


protocol MainConfiguratorProtocol: class {
    func configure(with viewController: MainViewController)
}

protocol MainViewProtocol: class {
    func initPickerView()
    func initDatePicker()
    func changeState(state: AlarmState)
    func showError(_ error: AlarmError) 
}

protocol MainPresenterProtocol: class {
    var sleepTimeList: [Int] {get}
    var selectedSleepTime: Int { get set }
    var selectedDate: Date? { get set }
    init(view: MainViewProtocol, alarm: AlarmServiceProtocol)
    func configureView()
    func playTap()
    func stopTap()
    func updateView()
}
