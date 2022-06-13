//
//  SortingOptionCell.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 06/06/22.
//

import UIKit

class SortingOptionCell: UITableViewCell {

    @IBOutlet weak var sortingOptionTitleLbl: UILabel!
    @IBOutlet weak var radioButtonImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = ColorConstant.colorBackground
        self.radioButtonImg.tintColor = ColorConstant.colorText
    }

    private func setTitle(title: String) {
        self.sortingOptionTitleLbl.text = title
    }
    
    private func configureSelectedStyle(isSelected: Bool) {
        let icon = isSelected ? IconConstant.radioButtonOn : IconConstant.radioButtonOff
        self.radioButtonImg.image = UIImage(named: icon)?.withRenderingMode(.alwaysTemplate)
    }
    
}

extension SortingOptionCell {
    
    static func instantiate(tableView: UITableView, indexPath: IndexPath, title: String, isSelected: Bool) -> SortingOptionCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortingOptionCell", for: indexPath) as? SortingOptionCell ?? SortingOptionCell()
        cell.setTitle(title: title)
        cell.configureSelectedStyle(isSelected: isSelected)
        return cell
    }
    
}
