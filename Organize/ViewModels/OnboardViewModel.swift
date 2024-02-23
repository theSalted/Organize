//
//  OnboardViewModel.swift
//  Organize
//
//  Created by Yuhao Chen on 2/23/24.
//

import Foundation
import Observation
import SwiftUI

@Observable
final class OnboardViewModel {
    enum Stage {
        case foreword, tip, technology
    }
    var stage: Stage = .foreword
    var showOnboarding = false
}
