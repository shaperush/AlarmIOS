//
//  MainConfigurator.swift
//  AlarmTest
//
//  Created by Dmitriy Zakharov on 03.05.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import Foundation


class MainConfigurator: MainConfiguratorProtocol {
    public func configure(with viewController: MainViewController) {
        let presenter = MainPresenter(view: viewController)
        viewController.presenter = presenter
    }
}
