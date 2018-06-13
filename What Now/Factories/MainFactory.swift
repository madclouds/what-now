//
//  MainFactory.swift
//  What Now
//
//  Created by Erik Bye on 6/5/18.
//  Copyright © 2018 Erik Bye. All rights reserved.
//

import UIKit

class MainFactory {
    func createMainModelViewController() -> MainViewController {
//        let databaseService = FirebaseDatabaseService()
        let databaseService = LocalStorageDatabaseService()
        let mainViewModel = MainViewModel(databaseService: databaseService)
        return MainViewController(databaseService: databaseService, viewModel: mainViewModel)
    }
}
