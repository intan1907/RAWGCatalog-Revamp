//
//  UICollectionView+ConfigureController.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 02/06/22.
//

import UIKit

public extension UICollectionView {
    
    func configure(fromController controller: UIViewController, cellName: [String], headerSectionName: String? = nil) {
        cellName.forEach { [weak self] name in
            self?.register(UINib(nibName: name, bundle: controller.nibBundle), forCellWithReuseIdentifier: name)
        }
        
        if let headerName = headerSectionName {
            self.register(UINib(nibName: headerName, bundle: controller.nibBundle), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerName)
        }
        
        self.delegate = controller as? UICollectionViewDelegate
        self.dataSource = controller as? UICollectionViewDataSource
    }
    
    func registerLoadMoreCell() {
        self.register(UINib(nibName: "LoadMoreCell", bundle: Bundle.main), forCellWithReuseIdentifier: "LoadMoreCell")
    }
    
}
