//
//  MainViewModel.swift
//  TwitterMenu
//
//  Created by Spencer Feng on 12/3/21.
//

import Foundation
import Combine

class MainViewModel: ToggleMenuResponder {
    // MARK: - output
    @Published private(set) var isMenuOpen = false
    
    func toggleMenu() {
        isMenuOpen.toggle()
    }
}
