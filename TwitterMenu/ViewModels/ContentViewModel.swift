//
//  ContentViewModel.swift
//  TwitterMenu
//
//  Created by Spencer Feng on 13/3/21.
//

import Foundation

class ContentViewModel {
    // MARK: - output
    @Published private(set) var isMenuOpen = false
    
    let toggleMenuResponder: ToggleMenuResponder
    
    init(toggleMenuResponder: ToggleMenuResponder) {
        self.toggleMenuResponder = toggleMenuResponder
    }
    
    
    @objc func toggleMenu() {
        toggleMenuResponder.toggleMenu()
        isMenuOpen.toggle()
    }
}
