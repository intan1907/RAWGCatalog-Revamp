//
//  LoadingView.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 20/07/21.
//

import UIKit

open class LoadingView: UIView {
    
    @IBOutlet weak var parentVw: UIView!
    @IBOutlet weak var progressActivity: UIActivityIndicatorView!
    @IBOutlet weak var errorMessageLbl: UILabel!
    @IBOutlet weak var emptyStateVw: UIView!
    @IBOutlet weak var emptyStateImg: UIImageView!
    @IBOutlet weak var emptyStateImgHeight: NSLayoutConstraint!
    @IBOutlet weak var reloadBtn: CustomButton!
    
    private var reloadHandler: (() -> Void)?
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        self.reloadBtn.configButton(bgColor: ColorConstant.colorTeal, textColor: ColorConstant.colorWhite, borderColor: ColorConstant.colorTeal, borderWidth: 1, font: UIFont.Poppins.semiBold.font(ofSize: 12))
    }
    
    // show the loading
    public func loadInView(view: UIView, isTransluscent: Bool, bgColor: UIColor) {
        parentVw.backgroundColor = !isTransluscent ? bgColor : ColorConstant.colorBackground
        emptyStateVw.isHidden = true
        progressActivity.tintColor = ColorConstant.colorGray
        progressActivity.isHidden = false
        progressActivity.startAnimating()
        frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.addSubview(self)
    }
    
    // show the message
    public func showEmptyView(view: UIView, image: String, imageHeight: CGFloat = 64, message: String, bgColor: UIColor, hintColor: UIColor, hideReloadBtn: Bool = true, reloadBtnHandler: (() -> Void)? = nil) {
        emptyStateVw.isHidden = false
        progressActivity.isHidden = true
        progressActivity.stopAnimating()
        
        backgroundColor = bgColor
        emptyStateImg.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
        emptyStateImg.tintColor = hintColor
        emptyStateImgHeight.constant = imageHeight
        errorMessageLbl.text = message
        errorMessageLbl.textColor = hintColor
        
        // setting the reload button
        self.reloadBtn.isHidden = hideReloadBtn
        self.reloadHandler = reloadBtnHandler
        
        frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.addSubview(self)
    }
    
    public func stop() {
        removeFromSuperview()
    }
    
    @IBAction func hideBtnAction(_ sender: UIButton) {
        self.reloadHandler?()
    }
    
}

extension LoadingView {
    
    public static func instantiateFromNib() -> LoadingView {
        return UINib(nibName: "LoadingView", bundle: Bundle.main).instantiate(withOwner: nil, options: [:])[0] as? LoadingView ?? LoadingView()
    }
    
}
