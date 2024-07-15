//
//  ButtonModel.swift
//  Demo
//
//  Created by Marco Ghaly on 16.07.24.
//  Copyright © 2024 Marco Ghaly. All rights reserved.
//

import Foundation
import SwiftUI

struct ButtonModel {
    let title: String
    let iconName: String
    let destinationView: () -> AnyView
}
