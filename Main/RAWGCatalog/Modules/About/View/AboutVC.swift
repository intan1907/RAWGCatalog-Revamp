//
//  AboutVC.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 13/09/21.
//

import UIKit
import Combine
import CoreModule
import AboutModule

class AboutVC: BaseVC {
    
    @IBOutlet weak var scrollVw: UIScrollView!
    @IBOutlet weak var contentVw: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var aboutUserLbl: UILabel!
    @IBOutlet weak var aboutAppLbl: UILabel!
    
    var presenter: AboutPresenter<
        Interactor<Any, ProfileModel, GetProfileRepository<GetProfileDataSource, ProfileTransformer>>,
        Interactor<Any, String, GetAboutAppRepository<GetAboutAppDataSource>>
    >!
            
    private var profile: ProfileModel?
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configAboutObservables()
        self.configInitialViews()
        self.presenter.getAboutApp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showLoading(view: self.view)
        self.presenter.getProfile()
    }
    
    @IBAction func editProfileBtnAction(_ sender: Any) {
        RAWGRouterManager.shared.router?.routeToEditProfile(caller: self, profile: self.profile)
    }
    
}

extension AboutVC {
    
    private func configAboutObservables() {
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
        
        self.presenter.$profile
            .subscribe(on: RunLoop.main)
            .sink { [weak self] profile in
                guard let self = self else { return }
                self.profile = profile
                self.configureView()
            }
            .store(in: &cancellables)
        
        self.presenter.$aboutApp
            .subscribe(on: RunLoop.main)
            .sink { [weak self] about in
                guard let self = self else { return }
                self.aboutAppLbl.text = about
            }
            .store(in: &cancellables)
        
        self.presenter.$errorMessage
            .subscribe(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] message in
                guard let self = self else { return }
                self.stopLoading()
                self.showMessage(message: message, showReloadBtn: true) {
                    self.showLoading(view: self.view)
                    self.presenter.getProfile()
                    self.presenter.getAboutApp()
                }
            }
            .store(in: &cancellables)
    }
    
    private func configInitialViews() {
        // background colors
        self.scrollVw.backgroundColor = ColorConstant.colorBackground
        self.contentVw.backgroundColor = ColorConstant.colorBackground
        
        // profile image
        self.profileImg.roundedCorner(radius: self.profileImg.frame.width / 2)
        
        self.configLoadingViews()
    }
    
    private func configureView() {
        guard let model = self.profile else { return }
        
        let frame = self.profileImg.frame
        if let img = model.profilePicture {
            self.profileImg.image = UIImage.cropToBounds(image: img, width: frame.width, height: frame.height)
        } else {
            self.profileImg.image = UIImage.cropToBounds(image: UIImage(named: IconConstant.notFound) ?? UIImage(), width: frame.width, height: frame.height)
        }
        
        self.fullNameLbl.text = model.fullName ?? "-"
        self.userNameLbl.text = model.username ?? "-"
        self.emailLbl.text = model.email ?? "-"
        self.aboutUserLbl.text = model.about ?? "-"
    }
    
}
