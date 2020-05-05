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
    public var selectedSleepTime = 0
    public var selectedDate: Date?
    
    public var sleepTimeList: [Int] {
        get {
            return [0, 5, 10, 15, 20]
        }
    }
    
    required init(view: MainViewProtocol, alarm: AlarmServiceProtocol) {
        self.view = view
        alarmService = alarm
        alarmService.alarmServiceDelegate = self
    }
    
    func configureView() {
        self.view?.initPickerView()
        self.view?.initDatePicker()
    }
    
    func updateView()  {
        self.view?.changeState(state: alarmService.currentState)
    }
    
    func stopTap() {
        alarmService.stopAlarm()
    }
    
    func playTap() {
        if alarmService.currentState == .idle {
            guard let date = selectedDate else {
                self.view?.showError(.emptyDate)
                return
            }
            alarmService.setAlarm(time: date, sleep: selectedSleepTime) { (success) in
                if !success {
                    self.view?.showError(.microphonePermission)
                }
            }
        } else if alarmService.currentState == .playing {
            alarmService.playePauseSong(isPlay: false)
        } else if alarmService.currentState == .pause {
            alarmService.playePauseSong(isPlay: true)
        }
    }
}

extension MainPresenter: AlarmServiceDelegate {
    func changeState() {
        let state = alarmService.currentState
        self.view?.changeState(state: state)
    }
}
