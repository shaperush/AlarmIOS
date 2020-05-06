//
//  MainViewController.swift
//  AlarmTest
//
//  Created by Dmitriy Zakharov on 04.05.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, MainViewProtocol {
    var presenter: MainPresenterProtocol!
    var configurator: MainConfiguratorProtocol = MainConfigurator()
    
    @IBOutlet weak var stopView: UIView!
    @IBOutlet weak var alarmView: UIView!
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var alarmTimeField: UITextField!
    @IBOutlet weak var sleepTimeField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    
    let pickerView = UIPickerView()
    let datePicker = UIDatePicker()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(with: self)
        presenter.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.updateView()
    }
    
    @IBAction func stopAction(_ sender: Any) {
        presenter.stopTap()
    }
    
    @IBAction func playAction(_ sender: Any) {
        presenter.playTap()
    }
    
    func showError(_ error: AlarmError) {
        let alertController = UIAlertController(title: "error", message: error.rawValue, preferredStyle: .alert)
        self.present(alertController,animated: true, completion: nil)
        alertController.dismiss(animated: true, completion: nil)
    }
    
    func changeState(state: AlarmState) {
        let startButtonLabel = "START"
        let playButtonLabel = "PLAY"
        let pauseButtonLabel = "PAUSE"
        
        self.stateLabel.text = state.rawValue
        self.alarmView.isHidden = true
        self.stopView.isHidden = true
        self.playButton.isHidden = false
        self.alarmTimeField.isEnabled = true
        self.sleepTimeField.isEnabled = true
        
        switch state {
        case .idle:
            self.alarmView.isHidden = false
            self.playButton.setTitle(startButtonLabel, for: .normal)
        case .playing:
            self.alarmView.isHidden = false
            self.playButton.setTitle(pauseButtonLabel, for: .normal)
            self.alarmTimeField.isEnabled = false
            self.sleepTimeField.isEnabled = false
        case .pause:
            self.alarmView.isHidden = false
            self.playButton.setTitle(playButtonLabel, for: .normal)
            self.alarmTimeField.isEnabled = false
            self.sleepTimeField.isEnabled = false
        case .recording:
            self.alarmView.isHidden = false
            self.playButton.isHidden = true
            self.alarmTimeField.isEnabled = false
            self.sleepTimeField.isEnabled = false
        case .alarm:
            self.stopView.isHidden = false
        }
    }
    
    func initPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.backgroundColor = .white
        
        let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.size.height, height: 40.0))
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButton(sender:)))
        doneButton.tag = 1
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        sleepTimeField.inputView = pickerView
        sleepTimeField.inputAccessoryView = toolbar
    }
    
    func initDatePicker() {
        let screenWidth = UIScreen.main.bounds.width
        datePicker.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 216)
        datePicker.backgroundColor = .white
        datePicker.datePickerMode = .time
        datePicker.addTarget(self, action: #selector(datePickerChange(sender:)), for: .valueChanged)
        let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.size.height, height: 40.0))
        toolbar.barStyle = .default
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButton(sender:)))
        doneButton.tag = 2
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        alarmTimeField.inputView = datePicker
        alarmTimeField.inputAccessoryView = toolbar
    }
    
    @objc func datePickerChange(sender: UIDatePicker) {
        presenter.selectedDate = sender.date
    }
    
    @objc func doneButton(sender: UIBarButtonItem) {
        let sleepTimePlaceholder = "off"
        
        if let date = presenter.selectedDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            alarmTimeField.text = formatter.string(from: date)
        }
        
        if presenter.selectedSleepTime > 0 {
            sleepTimeField.text = "\(presenter.selectedSleepTime) min"
        } else {
            sleepTimeField.text = sleepTimePlaceholder
        }
        sleepTimeField.resignFirstResponder()
        alarmTimeField.resignFirstResponder()
    }
}

extension MainViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presenter.sleepTimeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let time = presenter.sleepTimeList[row]
        let title = time > 0 ? "\(time) min" : "off"
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        presenter.selectedSleepTime = presenter.sleepTimeList[row]
    }
}


