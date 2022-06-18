//
//  GameDetailVC.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 04/06/22.
//

import UIKit
import Combine
import CoreModule
import GameModule

class GameDetailVC: BaseVC {
    
    private lazy var bookmarkBtn: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: IconConstant.favorite), style: .plain, target: self, action: #selector(self.bookmarkBtnAction(_:)))
    }()
    @IBOutlet weak var scrollVw: UIScrollView!
    @IBOutlet weak var contentVw: UIView!
    
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var modifiedLbl: UILabel!
    @IBOutlet weak var ratingCategoryLbl: UILabel! // exceptional, recommended, meh, skip
    @IBOutlet weak var descLbl: UILabel! // about
    @IBOutlet weak var releaseLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var metacriticLbl: UILabel!
    @IBOutlet weak var averagePlaytimeLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var platformLbl: UILabel!
    @IBOutlet weak var storeLbl: UILabel!
    
    var presenter: GameDetailPresenter<
        Interactor<Int, GameDetailModel, GetGameDetailRepository<GetFavoriteGamesLocaleDataSource, GetGameDetailRemoteDataSource, GameDetailTransformer>>,
        Interactor<GameDetailModel, Bool, UpdateFavoriteGameRepository<GetFavoriteGamesLocaleDataSource, GameDetailTransformer>>
    >!
    
    private var model: GameDetailModel?
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configGameDetailObservables()
        self.configInitialViews()
        
        self.doCallApi()
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func bookmarkBtnAction(_ sender: Any) {
        guard let obj = self.model?.copy() as? GameDetailModel else { return }
        
        let isFavorite = !(self.model?.isFavorite ?? false)
        obj.isFavorite = isFavorite
        self.showLoading(view: self.view)
        self.presenter.updateGameDetail(model: obj)
    }
    
}

extension GameDetailVC {
    
    private func configGameDetailObservables() {
        self.presenter.$isLoading
            .subscribe(on: RunLoop.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    self.showLoading(view: self.view)
                } else {
                    self.stopLoading()
                }
            }
            .store(in: &cancellables)
        
        self.presenter.$gameDetail
            .subscribe(on: RunLoop.main)
            .sink { [weak self] response in
                guard let self = self, let detail = response else { return }
                self.model = detail
                self.configureGameDetailViews()
                self.navigationItem.rightBarButtonItem = self.bookmarkBtn
            }
            .store(in: &cancellables)
        
        self.presenter.$isFavorite
            .subscribe(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] isFavorite in
                guard let self = self else { return }
                self.bookmarkBtn.image = UIImage(named: isFavorite ? IconConstant.favoriteFill : IconConstant.favorite)
                self.model?.isFavorite = isFavorite
            }
            .store(in: &cancellables)
        
        self.presenter.$errorMessage
            .subscribe(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] message in
                guard let self = self else { return }
                self.stopLoading()
                self.showMessage(message: message)
            }
            .store(in: &cancellables)
    }
    
    private func configBookmarkButton(isFav: Bool) {
        // automatically, this game is in favorite list
        self.bookmarkBtn.image = UIImage(named: isFav ? IconConstant.favoriteFill : IconConstant.favorite)
        if self.navigationItem.rightBarButtonItem == nil {
            self.navigationItem.rightBarButtonItem = self.bookmarkBtn
        }
    }
    
    private func configInitialViews() {
        // colors
        self.scrollVw.backgroundColor = ColorConstant.colorBackground
        self.contentVw.backgroundColor = ColorConstant.colorBackground
        
        self.configLoadingViews()
    }
    
    private func configureGameDetailViews() {
        // load image
        if let img = UIImage(data: self.model?.image ?? Data()) {
            self.backgroundImg.image = img
        } else {
            self.backgroundImg.setLoad(isLoad: true)
            self.backgroundImg.sd_setImage(with: URL(string: model?.imageUrl ?? "")) { [weak self] (img, err, _, _) in
                guard let self = self else { return }
                self.backgroundImg.setLoad(isLoad: false)
                if err == nil {
                    self.backgroundImg.image = img ?? UIImage(named: IconConstant.notFound)
                    self.model?.image = img?.jpegData(compressionQuality: 0.4)
                } else {
                    // show no image
                    self.backgroundImg.image = UIImage(named: IconConstant.notFound)
                }
            }
        }
        
        self.nameLbl.text = self.model?.name ?? "-"
        self.modifiedLbl.text = self.model?.lastModified ?? "-"
        
        let ratingCategory = self.model?.getRatingCategoryWithEmoji() ?? "-"
        self.ratingCategoryLbl.text = ratingCategory
        self.ratingCategoryLbl.isHidden = ratingCategory.isEmptyContent()
        
        self.descLbl.text = self.model?.about ?? "-"
        self.releaseLbl.text = self.model?.released
        self.ratingLbl.text = self.model?.getFormattedRating() ?? "-"
        self.metacriticLbl.text = self.model?.getFormattedMetacritic() ?? "-"
        self.averagePlaytimeLbl.text = self.model?.getFormattedPlaytime() ?? "-"
        self.platformLbl.text = self.model?.platforms ?? "-"
        self.genreLbl.text = self.model?.genres ?? "-"
        
        // setting store as bullets
        let storeNames = self.model?.getArrayStores() ?? []
        if storeNames.isEmpty || storeNames.first == "-" {
            self.storeLbl.text = TextConstant.unknown
        } else {
            let font = self.storeLbl.font ?? UIFont.Poppins.regular.font(ofSize: 12)
            self.storeLbl.attributedText = String.stringWithBullets(stringList: storeNames, font: font)
        }
        
        self.configBookmarkButton(isFav: self.model?.isFavorite ?? false)
    }
    
    private func doCallApi() {
        // hide bookmark button
        self.navigationItem.rightBarButtonItem = nil
        
        self.showLoading(view: self.view)
        self.presenter.getGameDetail()
    }
    
}
