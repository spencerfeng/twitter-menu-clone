//
//  ContentViewController.swift
//  TwitterMenu
//
//  Created by Spencer Feng on 28/2/21.
//

import UIKit
import Combine

class ContentViewController: UIViewController {
    
    // MARK: - Properties
    // View Model
    let viewModel: ContentViewModel

    // State
    var subscriptions = Set<AnyCancellable>()
    
    // UI components
    var toggleBtn: UIButton = {
        let btnBgImg = UIImage(systemName: "line.horizontal.3")
        let toggleBtn = UIButton()
        toggleBtn.setImage(btnBgImg, for: .normal)
        toggleBtn.alpha = 1.0
        let configuration = UIImage.SymbolConfiguration(pointSize: 26.0, weight: .regular)
        toggleBtn.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        return toggleBtn
    }()
    
    var topNavigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.backgroundColor = .white
        
        // get rid of the gray background color
        // reference: https://stackoverflow.com/questions/19226965/how-to-hide-uinavigationbar-1px-bottom-line
        navigationBar.isTranslucent = false
        
        // get rid of the bottom border
        // reference: https://stackoverflow.com/questions/19226965/how-to-hide-uinavigationbar-1px-bottom-line
        navigationBar.shadowImage = UIImage()
        
        
        return navigationBar
    }()
    
    var contentView: UILabel = {
        let label = UILabel()
        label.text = "Content View"
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    var overlayView: UIView = {
        let overlay = UIView()
        overlay.backgroundColor = .blue
        overlay.alpha = 0.0
        return overlay
    }()
    
    
    // MARK: - Initializers
    init(viewModel: ContentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBarItems()
        
        view.addSubview(topNavigationBar)
        topNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        
        // add tap gesture recognizer
        let tap = UITapGestureRecognizer(target: viewModel, action: #selector(ContentViewModel.toggleMenu))
        overlayView.addGestureRecognizer(tap)
        
        bindUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // get top inset
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let topInset = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        NSLayoutConstraint.activate([
            topNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topNavigationBar.topAnchor.constraint(equalTo: view.topAnchor, constant: topInset),
            topNavigationBar.widthAnchor.constraint(equalTo: view.widthAnchor),
            topNavigationBar.heightAnchor.constraint(equalToConstant: 44.0),
            
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.widthAnchor.constraint(equalToConstant: 200),
            contentView.heightAnchor.constraint(equalToConstant: 20),
            
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    // MARK: - Other Methods
    private func setupNavigationBarItems() {
        let item = UINavigationItem()
        
        toggleBtn.addTarget(viewModel, action: #selector(ContentViewModel.toggleMenu), for: .touchUpInside)
        item.leftBarButtonItem = UIBarButtonItem(customView: toggleBtn)
        
        topNavigationBar.items = [item]
    }
    
    private func bindUI() {
        viewModel
            .$isMenuOpen
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0.0,
                    usingSpringWithDamping: 1,
                    initialSpringVelocity: 10.0,
                    options: .curveEaseIn,
                    animations: {
                        self?.overlayView.alpha = result ? 0.4 : 0.0
                        self?.toggleBtn.alpha = result ? 0.0 : 1.0
                        self?.view.layoutIfNeeded()
                    },
                    completion: nil
                )
            }.store(in: &subscriptions)
    }
    
}
