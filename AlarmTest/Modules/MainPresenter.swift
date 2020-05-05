//
//  MainPresenter.swift
//  AlarmTest
//
//  Created by Dmitriy Zakharov on 03.05.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import Foundation


class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    unowned var alarmService: AlarmServiceProtocol
    weak var alarmServiceDelegate: AlarmServiceDelegate?
    
    public var sleepTimeList: [Int] {
        get {
            return [0, 5, 10, 15, 20]
        }
    }
    
    public var selectedSleepTime = 0
    public var selectedDate: Date?

    required init(view: MainViewProtocol, alarm: AlarmServiceProtocol) {
        self.view = view
        alarmService = alarm
        alarmServiceDelegate = alarmService.alarmServiceDelegate
    }
    
    func configureView() {
        self.view?.initPickerView()
        self.view?.initDatePicker()
        self.view?.changeState(state: alarmService.currentState)
    }
}

extension MainPresenter: AlarmServiceDelegate {
    func changeState(state: AlarmState) {
        self.view?.changeState(state: state)
        print("state")
    }
    
    
}
