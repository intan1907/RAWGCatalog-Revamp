//
//  StoreDetailVC.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 06/06/22.
//

import UIKit
import CoreModule
import StoreModule
import GameModule

class StoreDetailVC: BaseGamesVC {
    
    @IBOutlet weak var scrollVw: UIScrollView!
    @IBOutlet weak var containerVw: UIView!
    
    @IBOutlet weak var storeStack: UIStackView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var storeDescLbl: UILabel!
    
    @IBOutlet weak var gameTitleLbl: UILabel!
    @IBOutlet weak var seeAllGamesBtn: CustomButton!
    
    @IBOutlet weak var storeDomainBtn: CustomButton!
    
    var presenter: StoreDetailPresenter<
        Interactor<
            Int,
            StoreDetailModel,
            GetStoreDetailRepository<
                GetStoreDetailRemoteDataSource,
                StoreDetailTransformer
            >
        >,
        Interactor<
            GameParamModel,
            GamesModel,
            GetGamesRepository<GetGamesRemoteDataSource, GamesTransformer>
        >
    >!
    
    private var storeDetail: StoreDetailModel?
    private var domainUrl: URL!
    
    override var showLoadMore: Bool {
        return false
    }
    
    override func viewDidLoad() {
        self.configStoreDetailObservables()
        super.viewDidLoad()
    }
    
    override func doCallApi() {
        self.presenter.getStoreDetail()
    }
    
    override func configInitialViews() {
        self.scrollVw.backgroundColor = ColorConstant.colorBackground
        self.containerVw.backgroundColor = ColorConstant.colorBackground
        
        super.configInitialViews()
        
        self.gamesCollectionVw.configure(fromController: self, cellName: ["GameCell"])
        self.gamesCollectionVw.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 16, right: 0)
        self.seeAllGamesBtn.configButton(bgColor: ColorConstant.colorTeal, textColor: ColorConstant.colorWhite, font: UIFont.Poppins.semiBold.font(ofSize: 14))
        
        self.storeDomainBtn.configButton(bgColor: ColorConstant.colorGrayTransparent, textColor: ColorConstant.colorText, font: UIFont.Poppins.semiBold.font(ofSize: 14))
        
        self.scrollVw.refreshControl = self.refreshControl
    }
    
    @IBAction func seeAllGamesBtnAction(_ sender: UIButton) {
        // route to all games
        guard
            let storeId = self.storeDetail?.id,
            let storeName = self.storeDetail?.name
        else { return }
        
        RAWGRouterManager.shared.router?.routeToGames(caller: self, param: GameParamModel(store: storeId, storeName: storeName))
    }
    
    @IBAction func visitStorePageBtnAction(_ sender: UIButton) {
        if let url = self.domainUrl {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}

extension StoreDetailVC {
    
    func setupRequestCompletion() {
        self.presenter.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                if !isLoading {
                    self?.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
        
        self.presenter.$errorMessage
            .subscribe(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] error in
                guard let self = self else { return }
                self.stopLoading()
                self.refreshControl.endRefreshing()
                
                let errors = error.components(separatedBy: "_")
                let caller = errors.first ?? ""
                let message = errors.count > 1 ? errors[1] : caller
                
                if caller == TextConstant.storesRequest && !self.games.isEmpty {
                    self.showTopMessage(message: message, error: true)
                    self.isPossibleToLoadMore = false
                    self.gamesCollectionVw.reloadData()
                } else {
                    self.showMessage(message: message)
                }
            }
            .store(in: &cancellables)
    }
    
    func configStoreDetailObservables() {
        self.setupRequestCompletion()
        
        self.presenter.$storeDetail
            .subscribe(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] storeDetail in
                self?.storeDetail = storeDetail
                self?.configureStoreDetail()
            }
            .store(in: &cancellables)
        
        self.presenter.$games
            .dropFirst()
            .subscribe(on: RunLoop.main)
            .sink { [weak self] response in
                guard let self = self else { return }
                self.games = response?.games ?? []
                self.configureGamesCollectionHeight()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    if self.games.isEmpty {
                        self.showMessage(view: self.gamesCollectionVw, message: TextConstant.emptyGames)
                        self.seeAllGamesBtn.isHidden = true
                    } else {
                        self.seeAllGamesBtn.isHidden = false
                    }
                    self.gamesCollectionVw.reloadData()
                    
                    self.stopLoading()
                    self.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
    }
    
}

extension StoreDetailVC {
    
    func configureStoreDetail() {
        if let name = self.storeDetail?.name,
           !name.isEmptyContent() {
            self.titleLbl.text = name
            self.titleLbl.isHidden = false
            self.gameTitleLbl.text = TextConstant.storeFilteredHeaderTitle + " " + name
        } else {
            self.titleLbl.isHidden = true
            self.gameTitleLbl.text = TextConstant.gameHeaderTitle
        }
        
        if let description = self.storeDetail?.descriptionValue,
           !description.isEmptyContent() {
            if let htmlString = description.htmlAttributedString(fontFamily: UIFont.Poppins.regular.rawValue, pointSize: 12, color: ColorConstant.colorTextDarkGray) {
                let mutable = NSMutableAttributedString(attributedString: htmlString)
                self.storeDescLbl.attributedText = mutable.trimmedAttributedString()
                self.storeStack.isHidden = false
            } else {
                self.storeStack.isHidden = true
            }
        } else {
            self.storeStack.isHidden = true
        }
        
        if let domain = self.storeDetail?.domain,
           !domain.isEmptyContent() {
            self.validateStoreDomain(domain: domain)
        } else {
            self.storeDomainBtn.isHidden = true
        }
    }
    
    private func validateStoreDomain(domain: String) {
        if domain.hasPrefix("http://") {
            self.domainUrl = URL(string: domain)
        } else {
            self.domainUrl = URL(string: "http://" + domain)
        }
    }
    
}
