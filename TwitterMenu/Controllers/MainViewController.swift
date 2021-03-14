//
//  MainViewController.swift
//  TwitterMenu
//
//  Created by Spencer Feng on 28/2/21.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    // MARK: - Properties
    // View Model
    let viewModel: MainViewModel
    
    // Child View Controllers
    let contentVC: ContentViewController
    let menuVC: MenuViewController
    
    // State
    var subscriptions = Set<AnyCancellable>()
    
    // Other
    var menuVCLeadingConstraint: NSLayoutConstraint?
    
    
    // MARK: - Initializers
    init(viewModel: MainViewModel, contentVC: ContentViewController, menuVC: MenuViewController) {
        self.viewModel = viewModel
        self.contentVC = contentVC
        self.menuVC = menuVC
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.addChild(contentVC)
        self.view.addSubview(contentVC.view)
        contentVC.view.translatesAutoresizingMaskIntoConstraints = false
        contentVC.didMove(toParent: self)
        
        self.addChild(menuVC)
        self.view.addSubview(menuVC.view)
        menuVC.view.translatesAutoresizingMaskIntoConstraints = false
        menuVC.didMove(toParent: self)
        
        menuVCLeadingConstraint = NSLayoutConstraint(
            item: menuVC.view!,
            attribute: .leading,
            relatedBy: .equal,
            toItem: view,
            attribute: .leading,
            multiplier: 1.0,
            constant: -UIScreen.main.bounds.width * 0.6
        )
        
        menuVCLeadingConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            menuVC.view.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0),
            menuVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            menuVC.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            
            contentVC.view.leadingAnchor.constraint(equalTo: menuVC.view.trailingAnchor),
            contentVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            contentVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentVC.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0)
        ])
        
        bindUI()
        
    }
    
    
    // MARK: Other Methods
    private func bindUI() {
        viewModel
            .$isMenuOpen
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.menuVCLeadingConstraint?.constant = result ? 0 : -UIScreen.main.bounds.width * 0.6
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0.0,
                    usingSpringWithDamping: 1,
                    initialSpringVelocity: 10.0,
                    options: .curveEaseIn,
                    animations: {
                        self?.view.layoutIfNeeded()
                    },
                    completion: nil
                )
            }.store(in: &subscriptions)
    }

}
