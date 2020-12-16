//
//  ErrorView.swift
//  Demo
//
//  Created by Marco Ghaly on 16/12/2020.
//  Copyright © 2020 Marco Ghaly. All rights reserved.
//

import Foundation
import SwiftUI

protocol ErrorView: View {
    var errorViewModel: ErrorViewModel { get set }
}
