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

}

protocol MainPresenterProtocol: class {
    init(view: MainViewProtocol)
    func configureView()
}
