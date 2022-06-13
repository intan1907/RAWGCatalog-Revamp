//
//  GamesVC.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 05/06/22.
//

import UIKit
import Combine
import CoreModule
import GameModule
import MaterialComponents

class GamesVC: BaseGamesVC {
    
    @IBOutlet weak var searchContainerVw: UIView!
    @IBOutlet weak var searchTf: MDCOutlinedTextField!
    @IBOutlet weak var searchBtn: CustomButton!
    @IBOutlet weak var sortBtn: CustomButton!
    
    @IBOutlet weak var filterContainerVw: UIView!
    @IBOutlet weak var filterLbl: UILabel!
    
    @IBOutlet weak var collectionContainerVw: UIView!
    
    var presenter: GamesPresenter<
        Interactor<
            GameParamModel,
            GamesModel,
            GetGamesRepository<GetGamesRemoteDataSource, GamesTransformer>
        >
    >!
    
    var ordering: GameOrderingOption? // param
    
    // data
    var genreName: String = ""
    var storeName: String = ""
    
    override func viewDidLoad() {
        self.configGamesObservables()
        super.viewDidLoad()
    }
    
    internal override func doCallApi() {
        self.presenter.execute(page: self.currentPage, search: self.searchTf.text, ordering: self.ordering)
    }
    
    internal override func configInitialViews() {
        super.configInitialViews()
        
        self.gamesCollectionVw.configure(fromController: self, cellName: ["GameCell"])
        self.gamesCollectionVw.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        
        // search section
        self.searchContainerVw.backgroundColor = ColorConstant.colorNavBar
        self.searchTf.configStarterAppearance(titleText: "", backgroundColor: ColorConstant.colorNavBar)
        self.searchTf.delegate = self
        self.searchBtn.configButton(bgColor: ColorConstant.colorTeal, textColor: ColorConstant.colorWhite)
        self.searchBtn.setImage(icon: IconConstant.search)
        self.sortBtn.configButton(bgColor: ColorConstant.colorGrayTransparent, textColor: ColorConstant.colorText)
        self.sortBtn.setImage(icon: IconConstant.settings)
        
        // filter section
        self.filterContainerVw.backgroundColor = ColorConstant.colorNavBar
        
        self.collectionContainerVw.backgroundColor = ColorConstant.colorBackground
    }
    
    @IBAction func searchBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.currentPage = 1
        self.totalData = 0
        self.doCallApi()
    }
    
    @IBAction func sortBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        RAWGRouterManager.shared.router?.routeToGameSorting(caller: self, selectedOption: self.ordering, completion: { [weak self] ordering in
            guard let self = self else { return }
            self.ordering = ordering
            if self.ordering == .added || self.ordering == nil {
                self.sortBtn.setImage(icon: IconConstant.settings)
            } else {
                self.sortBtn.setImage(icon: IconConstant.settingsFill)
            }
            
            self.currentPage = 1
            self.totalData = 0
            self.doCallApi()
        })
    }
    
}

extension GamesVC {
    
    func setupRequestCompletion() {
        self.presenter.$isLoading
            .subscribe(on: RunLoop.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    if !self.refreshControl.isRefreshing && self.currentPage == 1 {
                        self.showLoading(view: self.collectionContainerVw)
                    }
                } else {
                    self.stopLoading()
                    if self.games.isEmpty {
                        self.showMessage(view: self.collectionContainerVw, message: TextConstant.emptyGames)
                    }
                    self.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
        
        self.presenter.$errorMessage
            .dropFirst()
            .subscribe(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self = self else { return }
                self.stopLoading()
                // data kosong
                if self.games.isEmpty {
                    self.showMessage(view: self.collectionContainerVw, message: TextConstant.emptyGames)
                } else {
                    // ada data
                    self.showTopMessage(message: message, error: true)
                    self.isPossibleToLoadMore = false
                    self.gamesCollectionVw.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
    }
    
    func configGamesObservables() {
        self.setupRequestCompletion()
        
        self.presenter.$genreName
            .subscribe(on: RunLoop.main)
            .sink { [weak self] response in
                guard let self = self else { return }
                self.genreName = response
                self.configFilterLabel()
            }
            .store(in: &cancellables)
        
        self.presenter.$storeName
            .subscribe(on: RunLoop.main)
            .sink { [weak self] response in
                guard let self = self else { return }
                self.storeName = response
                self.configFilterLabel()
            }
            .store(in: &cancellables)
        
        self.presenter.$games
            .subscribe(on: RunLoop.main)
            .sink { [weak self] response in
                guard let self = self else { return }

                self.currentPage += 1
                self.totalData = response?.totalData ?? 0

                if self.currentPage == 2 { // current result is page 1
                    self.games = response?.games ?? []
                } else {
                    self.games.append(contentsOf: response?.games ?? [])
                }
                self.isPossibleToLoadMore = self.games.count < self.totalData

                self.gamesCollectionVw.reloadData()
            }
            .store(in: &cancellables)
    }
    
}

extension GamesVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.shouldChangeCharacters(in: range, replacementString: string)
    }
    
}

extension GamesVC {
    
    private func configFilterLabel() {
        if !self.genreName.isEmptyContent() {
            self.filterLbl.text = self.genreName + " " + TextConstant.gameHeaderTitle
            self.filterContainerVw.isHidden = false
        } else if !self.storeName.isEmptyContent() {
            self.filterLbl.text = TextConstant.storeFilteredHeaderTitle + " " + self.storeName
            self.filterContainerVw.isHidden = false
        } else {
            self.filterContainerVw.isHidden = true
        }
    }
    
}
