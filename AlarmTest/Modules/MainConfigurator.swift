//
//  MainConfigurator.swift
//  AlarmTest
//
//  Created by Dmitriy Zakharov on 03.05.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import Foundation
import UIKit

class MainConfigurator: MainConfiguratorProtocol {
    public func configure(with viewController: MainViewController) {
        let app = UIApplication.shared.delegate as! AppDelegate
        let presenter = MainPresenter(view: viewController, alarm: app.alarmService)
        viewController.presenter = presenter
    }
}
