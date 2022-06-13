//
//  EditProfileVC.swift
//  RAWGCatalog
//
//  Created by Intan Nurjanah on 04/06/22.
//

import UIKit
import MaterialComponents
import Combine
import CoreModule
import AboutModule

class EditProfileVC: BaseVC {
    
    @IBOutlet weak var scrollVw: UIScrollView!
    @IBOutlet weak var contentVw: UIView!
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var editPhotoBtn: UIButton!
    
    private lazy var imagePicker: UIImagePickerController = UIImagePickerController()
    
    @IBOutlet weak var fullNameTf: MDCOutlinedTextField!
    @IBOutlet weak var usernameTf: MDCOutlinedTextField!
    @IBOutlet weak var emailTf: MDCOutlinedTextField!
    @IBOutlet weak var aboutStudentTv: MDCOutlinedTextArea!
    @IBOutlet weak var submitBtn: CustomButton!
    
    var presenter: EditProfilePresenter<
        Interactor<Any, ProfileModel, GetProfileRepository<GetProfileDataSource, ProfileTransformer>>,
        Interactor<ProfileModel, Bool, SaveProfileRepository<SaveProfileDataSource, ProfileTransformer>>
    >!
    
    private var profile: ProfileModel?
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configEditProfileObservables()
        self.configureView()
        
        self.showLoading(view: self.view)
        self.presenter.getProfile()
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editPhotoBtnAction(_ sender: Any) {
        self.doChangeImage()
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        self.view.endEditing(true)
        self.setDefaultInput()
        
        let param = ProfileModel(
            profilePicture: self.profileImg.image,
            fullName: self.fullNameTf.text ?? "-",
            username: self.usernameTf.text ?? "-",
            email: self.emailTf.text ?? "-",
            about: self.aboutStudentTv.textView.text ?? "-"
        )
        self.presenter.saveProfile(profile: param)
    }
}

extension EditProfileVC: UITextFieldDelegate {
    
    private func setDefaultInput() {
        self.fullNameTf.setToDefault()
        self.usernameTf.setToDefault()
        self.emailTf.setToDefault()
        self.aboutStudentTv.setToDefault()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.fullNameTf:
            self.fullNameTf.resignFirstResponder()
            self.usernameTf.becomeFirstResponder()
        case self.usernameTf:
            self.usernameTf.resignFirstResponder()
            self.emailTf.becomeFirstResponder()
        case self.emailTf:
            self.emailTf.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.shouldChangeCharacters(in: range, replacementString: string)
    }
    
}

extension EditProfileVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.shouldChangeCharacters(in: range, replacementString: text)
    }
    
}

extension EditProfileVC {
    
    private func configEditProfileObservables() {
        self.presenter.$isLoading
            .receive(on: RunLoop.main)
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
            .receive(on: RunLoop.main)
            .sink { [weak self] profile in
                guard let self = self else { return }
                self.profile = profile
                self.fillForm()
            }
            .store(in: &cancellables)
        
        self.presenter.$isProfileSaved
            .receive(on: RunLoop.main)
            .sink { [weak self] isSaved in
                guard let self = self, isSaved else { return }
                self.showTopMessage(message: TextConstant.successSaveProfile, error: false)
                self.backBtnAction(self)
            }
            .store(in: &cancellables)
        
        self.presenter.$errorMessage
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] message in
                guard let self = self else { return }
                self.stopLoading()
                self.showMessage(message: message)
            }
            .store(in: &cancellables)
    }
    
    private func configureView() {
        // colors
        self.scrollVw.backgroundColor = ColorConstant.colorBackground
        self.contentVw.backgroundColor = ColorConstant.colorBackground
        
        self.configLoadingViews()
        
        // rounded profile picture
        self.profileImg.roundedCorner(radius: self.profileImg.frame.width / 2)
        
        // rounded button edit
        self.editPhotoBtn.roundedCorner(radius: self.editPhotoBtn.frame.width / 2)
        
        self.configTextField(textField: self.fullNameTf)
        self.configTextField(textField: self.usernameTf)
        self.configTextField(textField: self.emailTf)
        
        self.aboutStudentTv.configStarterAppearance(titleText: TextConstant.aboutStudentTextFieldTitle)
        self.aboutStudentTv.placeholder = TextConstant.aboutStudentTextFieldTitle
        self.aboutStudentTv.textView.delegate = self
        
        self.submitBtn.configButton(bgColor: ColorConstant.colorTeal, textColor: ColorConstant.colorWhite)
        self.submitBtn.setActiveDeactive(isActive: false)
        
        self.setupTextFieldChangeNotification()
    }
    
    private func configTextField(textField: MDCOutlinedTextField) {
        textField.configStarterAppearance()
        textField.delegate = self
    }
    
    private func configTexFieldState(textField: MDCOutlinedTextField, isTextValid: Bool, errorMessage: String) {
        if isTextValid {
            textField.setToDefault()
        } else {
            textField.setToError(errorMessage: errorMessage)
        }
    }
    
    private func fillForm() {
        guard let model = self.profile else { return }
        
        // profile pict
        let frame = self.profileImg.frame
        if let img = model.profilePicture {
            self.profileImg.image = UIImage.cropToBounds(image: img, width: frame.width, height: frame.height)
        } else {
            self.profileImg.image = UIImage.cropToBounds(image: UIImage(named: IconConstant.notFound) ?? UIImage(), width: frame.width, height: frame.height)
        }
        // full name
        self.fullNameTf.text = model.fullName ?? "-"
        // username
        self.usernameTf.text = model.username ?? "-"
        // email
        self.emailTf.text = model.email ?? "-"
        // about
        self.aboutStudentTv.textView.text = model.about ?? "-"
        self.aboutStudentTv.sizeToFit()
    }
    
    private func setupTextFieldChangeNotification() {
        let photoPublisher = self.profileImg.publisher(for: \.image, options: .new)
            .map { $0 != nil }
        
        let namePublisher = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self.fullNameTf)
            .map { ($0.object as? UITextField)?.text }
            .replaceNil(with: "")
            .map { $0.isValidAlphabet() && $0.count >= 6 }
        
        namePublisher.sink { [weak self] isValidName in
            guard let self = self else { return }
            self.configTexFieldState(textField: self.fullNameTf, isTextValid: isValidName, errorMessage: TextConstant.fullnameErrorMessage)
        }.store(in: &cancellables)
        
        let usernamePublisher = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self.usernameTf)
            .map { ($0.object as? UITextField)?.text }
            .replaceNil(with: "")
            .map { $0.count >= 6 }
        
        usernamePublisher.sink { [weak self] isValidUsername in
            guard let self = self else { return }
            self.configTexFieldState(textField: self.usernameTf, isTextValid: isValidUsername, errorMessage: TextConstant.usernameErrorMessage)
        }.store(in: &cancellables)
        
        let emailPublisher = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self.emailTf)
            .map { ($0.object as? UITextField)?.text }
            .replaceNil(with: "")
            .map { $0.isValidEmail() }
        
        emailPublisher.sink { [weak self] isValidEmail in
            guard let self = self else { return }
            self.configTexFieldState(textField: self.emailTf, isTextValid: isValidEmail, errorMessage: TextConstant.emailErrorMessage)
        }.store(in: &cancellables)
        
        let aboutStudentPublisher = NotificationCenter.default
            .publisher(for: UITextView.textDidChangeNotification, object: self.aboutStudentTv.textView)
            .map { ($0.object as? UITextView)?.text }
            .replaceNil(with: "")
            .map { $0.count > 50 }
        
        aboutStudentPublisher.sink { [weak self] isValidAbout in
            guard let self = self else { return }
            if isValidAbout {
                self.aboutStudentTv.setToDefault()
            } else {
                self.aboutStudentTv.setToError(errorMessage: TextConstant.aboutStudentErrorMessage)
            }
        }.store(in: &cancellables)
        
        // diasumsikan semua nilai awal semua data dari local db adalah valid => ditambahkan prepend(true)
        let validFieldPublisher = Publishers.CombineLatest4(
            namePublisher.prepend(true),
            usernamePublisher.prepend(true),
            emailPublisher.prepend(true),
            aboutStudentPublisher.prepend(true)
        ).map { validFullName, validUsername, validPassword, validAboutStudent in
            validFullName && validUsername && validPassword && validAboutStudent
        }
        
        let validFormPublisher = Publishers.CombineLatest(photoPublisher, validFieldPublisher).map { $0 && $1 }
        
        validFormPublisher
            .dropFirst() // drop first untuk membuat button tidak langsung enable (karena textfield belum berubah)
            .sink { [weak self] isValid in
                self?.submitBtn.setActiveDeactive(isActive: isValid)
            }
            .store(in: &cancellables)
    }
    
}

// MARK: Config Image Picker
extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func doChangeImage() {
        self.imagePicker.delegate = self
        
        let galleryAction: UIAlertAction = UIAlertAction(title: TextConstant.imagePickerGallery, style: .default) { _ in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)
        }
        
        let cameraAction: UIAlertAction = UIAlertAction(title: TextConstant.imagePickerCamera, style: .default) { _ in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: TextConstant.cancel, style: .cancel, handler: nil)
        
        self.actionSheet(withTitle: nil, message: nil, actions: [galleryAction, cameraAction, cancelAction])
    }
    
    private func actionSheet(withTitle title: String?, message: String?, actions: [UIAlertAction]) {
        let controller: UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
        for action in actions {
            controller.addAction(action)
        }
        controller.modalPresentationStyle = .fullScreen
        if let popoverController = controller.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var newImage: UIImage?
        if let image = info[.editedImage] as? UIImage {
            newImage = image
        } else if let image = info[.originalImage] as? UIImage {
            newImage = image
        }
        self.imagePicker.dismiss(animated: true) {
            self.profileImg.setLoad(isLoad: true)
            // load image
            let frame = self.profileImg.frame
            self.profileImg.image = UIImage.cropToBounds(image: newImage ?? (UIImage(named: IconConstant.notFound) ?? UIImage()), width: frame.width, height: frame.height)
            self.profileImg.setLoad(isLoad: false)
        }
    }
}
