//
//  MenuViewController.swift
//  TwitterMenu
//
//  Created by Spencer Feng on 28/2/21.
//

import UIKit

class MenuViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: MenuViewModel
    
    var menuView: UILabel = {
        let label = UILabel()
        label.text = "Menu View"
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    
    // MARK: - Initializers
    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(menuView)
        menuView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            menuView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            menuView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            menuView.widthAnchor.constraint(equalToConstant: 200),
            menuView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}
