//
//  LoadingViewModel.swift
//  Demo
//
//  Created by Marco Ghaly on 16/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation

enum LoadingViewStyle: CaseIterable {
    case normal
    case dialog
}

struct LoadingViewModel {
    var style = LoadingViewStyle.normal
    var title: String?
    var message: String?
}
