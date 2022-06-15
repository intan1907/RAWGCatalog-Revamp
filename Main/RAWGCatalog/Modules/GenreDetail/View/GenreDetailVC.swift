//
//  GenreDetailVC.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 05/06/22.
//

import UIKit
import Combine
import CoreModule
import GenreModule
import GameModule

class GenreDetailVC: BaseGamesVC {
    
    @IBOutlet weak var scrollVw: UIScrollView!
    @IBOutlet weak var containerVw: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var genreDescLbl: UILabel!
    
    @IBOutlet weak var seeAllGamesBtn: CustomButton!
    
    var presenter: GenreDetailPresenter<
        Interactor<
            Int,
            GenreDetailModel,
            GetGenreDetailRepository<
                GetGenreDetailRemoteDataSource,
                GenreDetailTransformer
            >
        >,
        Interactor<
            GameParamModel,
            GamesModel,
            GetGamesRepository<GetGamesRemoteDataSource, GamesTransformer>
        >
    >!
    
    private var genreDetail: GenreDetailModel?
    
    override var showLoadMore: Bool {
        return false
    }
    
    override func viewDidLoad() {
        self.configGenreDetailObservables()
        super.viewDidLoad()
    }
    
    override func doCallApi() {
        self.presenter.getGenreDetail()
    }
    
    override func configInitialViews() {
        self.scrollVw.backgroundColor = ColorConstant.colorBackground
        self.containerVw.backgroundColor = ColorConstant.colorBackground
        
        super.configInitialViews()
        
        self.gamesCollectionVw.configure(fromController: self, cellName: ["GameCell"])
        self.gamesCollectionVw.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 16, right: 0)
        self.seeAllGamesBtn.configButton(bgColor: ColorConstant.colorTeal, textColor: ColorConstant.colorWhite, font: UIFont.Poppins.semiBold.font(ofSize: 14))
        
        self.scrollVw.refreshControl = self.refreshControl
    }
    
    @IBAction func seeAllGamesBtnAction() {
        // route to all games
        guard
            let genreId = self.genreDetail?.id,
            let genreName = self.genreDetail?.name
        else { return }
        
        RAWGRouterManager.shared.router?.routeToGames(caller: self, param: GameParamModel(genre: genreId, genreName: genreName))
    }
    
}

extension GenreDetailVC {
    
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
                
                if caller == TextConstant.genresRequest {
                    // ada data, hanya show error via top message
                    if !self.games.isEmpty {
                        self.showTopMessage(message: message, error: true)
                        self.isPossibleToLoadMore = false
                        self.gamesCollectionVw.reloadData()
                    } else {
                        self.showMessage(message: message)
                    }
                } else {
                    self.showMessage(message: message)
                }
            }
            .store(in: &cancellables)
    }
    
    func configGenreDetailObservables() {
        self.setupRequestCompletion()
        
        self.presenter.$genreDetail
            .subscribe(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] genreDetail in
                self?.genreDetail = genreDetail
                self?.configureGenreDetail()
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

extension GenreDetailVC {
    
    func configureGenreDetail() {
        if let name = self.genreDetail?.name,
           !name.isEmptyContent() {
            self.titleLbl.text = name + " " + TextConstant.gameHeaderTitle
        } else {
            self.titleLbl.text = TextConstant.gameHeaderTitle
        }
        
        if let description = self.genreDetail?.descriptionValue,
           !description.isEmptyContent() {
            if let htmlString = description.htmlAttributedString(fontFamily: UIFont.Poppins.regular.rawValue, pointSize: 12, color: ColorConstant.colorTextDarkGray) {
                let mutable = NSMutableAttributedString(attributedString: htmlString)
                self.genreDescLbl.attributedText = mutable.trimmedAttributedString()
                self.genreDescLbl.isHidden = false
            } else {
                self.genreDescLbl.isHidden = true
            }
        } else {
            self.genreDescLbl.isHidden = true
        }
    }
    
}
