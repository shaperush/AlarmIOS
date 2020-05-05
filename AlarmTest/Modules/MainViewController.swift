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
    
    @IBOutlet weak var alarmTimeField: UITextField!
    @IBOutlet weak var sleepTimeField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    
    let pickerView = UIPickerView()
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(with: self)
        presenter.configureView()
        

        
        
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        do {
//            let fileURLs = try FileManager.default.contentsOfDirectory(at: paths[0], includingPropertiesForKeys: nil)
//            print(fileURLs)
//        } catch {
//            print("Error while enumerating files  \(error.localizedDescription)")
//        }
    }
    
    
    

    @IBAction func playAction(_ sender: Any) {
    
    }
    
    func changeState(state: AlarmState) {
        self.alarmView.isHidden = true
        self.stopView.isHidden = true
        switch state {
        case .idle:
            self.alarmView.isHidden = false
        case .playing:
            self.alarmView.isHidden = false
        case .pause:
            self.alarmView.isHidden = false
        case .recording:
            self.alarmView.isHidden = false
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
        if let date = presenter.selectedDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            alarmTimeField.text = formatter.string(from: date)
        }
        
        if presenter.selectedSleepTime > 0 {
            sleepTimeField.text = "\(presenter.selectedSleepTime) min"
        } else {
            sleepTimeField.text = "off"
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


