//
//  ViewController.swift
//  AlarmTest
//
//  Created by Dmitriy Zakharov on 03.05.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import UIKit


class MainViewController: UIViewController, MainViewProtocol {
    var presenter: MainPresenterProtocol!
    var configurator: MainConfiguratorProtocol = MainConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configurator.configure(with: self)
        presenter.configureView()
    }
}

