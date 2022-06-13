//
//  GameSortingVC.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 06/06/22.
//

import UIKit
import Combine
import GameModule

class GameSortingVC: BaseVC {
    
    @IBOutlet weak var scrollVw: UIScrollView!
    @IBOutlet weak var containerVw: UIView!
    @IBOutlet weak var tblVw: DynamicTableView!
    @IBOutlet weak var applyBtn: CustomButton!
    
    var presenter: GameSortingPresenter!
    
    private var sortingOptions: [GameOrderingOption] = []
    private var selectedSortingOption: GameOrderingOption?
    
    var completion: ((GameOrderingOption?) -> Void)?
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupGameSortingObservables()
        self.configInitialViews()
        self.presenter.getSortingOptions()
    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true)
    }
    
    @IBAction func applyBtnAction(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: { [weak self] in
            self?.completion?(self?.selectedSortingOption)
        })
    }
    
}

extension GameSortingVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sortingOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = self.sortingOptions[indexPath.row].title
        let isSelected = (title == self.selectedSortingOption?.title)
        let cell = SortingOptionCell.instantiate(tableView: tableView, indexPath: indexPath, title: title, isSelected: isSelected)
        
        return cell
    }
    
}

extension GameSortingVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedSortingOption = self.sortingOptions[indexPath.row]
        tableView.reloadData()
    }
    
}

extension GameSortingVC {
    
    func setupGameSortingObservables () {
        self.presenter.$sortingOptions
            .subscribe(on: RunLoop.main)
            .sink { [weak self] options in
                guard let self = self else { return }
                self.sortingOptions = options
                self.tblVw.reloadData()
            }
            .store(in: &cancellables)
        
        self.presenter.$selectedOption
            .subscribe(on: RunLoop.main)
            .sink { [weak self] selectedOption in
                self?.selectedSortingOption = selectedOption ?? .added
            }
            .store(in: &cancellables)
    }
    
    func configInitialViews() {
        self.view.backgroundColor = ColorConstant.colorBackground
        self.scrollVw.backgroundColor = ColorConstant.colorBackground
        self.containerVw.backgroundColor = ColorConstant.colorBackground
        self.tblVw.backgroundColor = ColorConstant.colorBackground
        
        self.tblVw.register(UINib(nibName: "SortingOptionCell", bundle: Bundle.main), forCellReuseIdentifier: "SortingOptionCell")
        self.tblVw.dataSource = self
        self.tblVw.delegate = self
        self.tblVw.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        
        self.applyBtn.configButton(bgColor: ColorConstant.colorTeal, textColor: ColorConstant.colorWhite, font: UIFont.Poppins.semiBold.font(ofSize: 14))
    }
    
}
