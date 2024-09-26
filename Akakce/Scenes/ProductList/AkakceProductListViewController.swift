//
//  AkakceProductListViewController.swift
//  Akakce
//
//  Created by Sercan Deniz on 24.09.2024.
//

import Foundation
import UIKit

final class AkakceProductListViewController: AkakceBaseViewController<AkakceProductListViewModel> {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var currentOrientation = UIDevice.current.orientation
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchProducts()
        viewModel.fetchHorizontalProducts("5")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getInitialOrientationStatus()
        setCollectionViewScrollDirection()
        
        viewModel.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(orientationStatus), name: UIDevice.orientationDidChangeNotification, object: nil)
        collectionView.register(UINib(nibName: "AkakceProductCollectionCell", bundle: nil), forCellWithReuseIdentifier: AkakceProductCollectionCell.identifier)
        
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func orientationStatus() {
        let orientation = UIDevice.current.orientation
        if orientation.isLandscape {
            currentOrientation = orientation
        } else {
            currentOrientation = orientation
        }
        self.collectionView.reloadData()
        setCollectionViewScrollDirection()
    }

    private func setupUI() {
        navigationItem.title = "Akakçe"
    }
    
    private func getInitialOrientationStatus() {
        currentOrientation = UIDevice.current.orientation
    }
    
    private func setCollectionViewScrollDirection() {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        if currentOrientation.isLandscape {
            layout?.scrollDirection = .horizontal
        } else {
            layout?.scrollDirection = .vertical
        }
    }
}

extension AkakceProductListViewController: AkakceProductListViewModelDelegate {
    func didFetchProducts() {
        hideIndicator()
        collectionView.reloadData()
    }
    
    func didFetchHorizontalProducts() {
        hideIndicator()
        collectionView.reloadData()
    }
    
    func errorFetchProductList(error: Error?, message: String?) {
        hideIndicator()
        let action = [UIAlertAction(title: "Tamam", style: .destructive)]
        if let error = error {
            self.showAlert(title: "Hata", message: error.localizedDescription, style: .alert, actions: action)
        } else {
            self.showAlert(title: "Hata", message: message, style: .alert, actions: action)
        }
    }
    
    func callIndicator() {
        showIndicator()
    }
}

extension AkakceProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.bounds.width
        let spacing: CGFloat = 10
        let cellWidth = (totalWidth - (spacing * 1)) / 2
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

extension AkakceProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentOrientation.isLandscape {
            let vc = AkakceProductDetailViewController(id: viewModel.horizontalProducts[indexPath.row].id)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = AkakceProductDetailViewController(id: viewModel.products[indexPath.row].id)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension AkakceProductListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentOrientation.isLandscape {
            return viewModel.horizontalProducts.count
        } else {
            return viewModel.products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if currentOrientation.isLandscape {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AkakceProductCollectionCell.identifier, for: indexPath) as! AkakceProductCollectionCell
            cell.configure(imageURL: viewModel.horizontalProducts[indexPath.row].image, title: viewModel.horizontalProducts[indexPath.row].title, price: viewModel.horizontalProducts[indexPath.row].price)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AkakceProductCollectionCell.identifier, for: indexPath) as! AkakceProductCollectionCell
            cell.configure(imageURL: viewModel.products[indexPath.row].image, title: viewModel.products[indexPath.row].title, price: viewModel.products[indexPath.row].price)
            return cell
        }
    }
}
