//
//  MainPresenter.swift
//  AlarmTest
//
//  Created by Dmitriy Zakharov on 03.05.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import Foundation


class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol!

    required init(view: MainViewProtocol) {
        self.view = view
    }
    
    func configureView() {
        
    }
}
