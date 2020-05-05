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
     let player = PlayerService()
    
    @IBAction func play(_ sender: Any) {
       
        player.startSong(songName: "alarm.mp3")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configurator.configure(with: self)
        presenter.configureView()
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: paths[0], includingPropertiesForKeys: nil)
            print(fileURLs)
        } catch {
            print("Error while enumerating files  \(error.localizedDescription)")
        }
    }
}
