//
//  AkakceBaseViewController.swift
//  Akakce
//
//  Created by Sercan Deniz on 24.09.2024.
//

import Foundation
import UIKit

class AkakceBaseViewController<TViewModel: AkakceBaseViewModel>: UIViewController {
    
    public var viewModel: TViewModel!
    public var activityIndicator = UIActivityIndicatorView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = TViewModel()
        setupNavigationBar()
        setupActivityIndicator()
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        
        appearance.backgroundColor = ColorSet.akakceBlueColor
        
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: ColorSet.akakceMainColor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationController?.navigationBar.tintColor = ColorSet.akakceMainColor
    }
    
    private func setupActivityIndicator() {
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        activityIndicator.color = .black
        activityIndicator.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        activityIndicator.backgroundColor = .black.withAlphaComponent(0.5)
        view.bringSubviewToFront(activityIndicator)
        view.addSubview(activityIndicator)
    }
    
    func showIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
    }
    
    func hideIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func showAlert(title: String? = nil,
                   message: String?,
                   style: UIAlertController.Style,
                   actions: [UIAlertAction]? = nil) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: style)
        
        actions?.forEach { alertController.addAction($0) }
        present(alertController, animated: true)
    }
}
