//
//  AuthlabsAddMarkerDatilViewConctroller.swift
//  Authlabs_App
//
//  Created by Matthew on 4/30/24.
//

import UIKit
import Then
import SwiftUI

protocol MarkerRegistrationViewControllerDelegate: AnyObject {
    func setImage(_ image: UIImage)
}

final class AuthlabsAddAssetDatilViewConctroller: UIViewController {
    private let markerViewModel: MarkerViewModel
    weak var delegate: MarkerImageCollectionViewControllerDelegate?
    private var markerImage: MarkerImage?
    
    lazy var markerImageView = UIImageView().then {
        let skeletonImage = UIImage(named: "img_addAssets_isEmpty")
        $0.image = skeletonImage
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var buttonStackView = UIStackView().then {
        $0.addArrangedSubview(libraryButton)
        $0.addArrangedSubview(cameraButton)
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    
    lazy var libraryButton = UIButton().then {
        $0.layer.frame = CGRect(x: 0,
                                y: 0,
                                width: Int(UIScreen.main.bounds.width / 4),
                                height: Int(UIScreen.main.bounds.height) / 12)
        $0.layer.cornerRadius = $0.layer.frame.height / 2.5
        $0.backgroundColor = UIColor(hexCode: "3177FF")
        $0.setImage(UIImage(systemName: "photo.fill.on.rectangle.fill"), for: .normal)
        $0.tintColor = .white
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 10
        configuration.preferredSymbolConfigurationForImage =
        UIImage.SymbolConfiguration(font: .systemFont(ofSize: 11, weight: .semibold))
        var titleAttr = AttributedString.init("Add Image")
        titleAttr.font = .systemFont(ofSize: 14.0, weight: .semibold)
        configuration.attributedTitle = titleAttr
        $0.configuration = configuration
        $0.addTarget(self, action: #selector(presentPhotoLibrary), for: .touchUpInside)
    }
    
    lazy var cameraButton = UIButton().then {
        $0.layer.frame = CGRect(x: 0,
                                y: 0,
                                width: Int(UIScreen.main.bounds.width / 4),
                                height: Int(UIScreen.main.bounds.height) / 12)
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor(hexCode: "3177FF").cgColor
        $0.layer.cornerRadius = $0.layer.frame.height / 2.5
        $0.backgroundColor = UIColor(hexCode: "ffffff")
        $0.setImage(UIImage(systemName: "camera.shutter.button.fill"), for: .normal)
        $0.tintColor = UIColor(hexCode: "3177FF")
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 4
        configuration.preferredSymbolConfigurationForImage =
        UIImage.SymbolConfiguration(font: .systemFont(ofSize: 11, weight: .semibold))
        var titleAttr = AttributedString.init("Take a Photo")
        titleAttr.font = .systemFont(ofSize: 14.0, weight: .semibold)
        configuration.attributedTitle = titleAttr
        $0.configuration = configuration
        $0.addTarget(self, action: #selector(presentCamera), for: .touchUpInside)
    }
    
    lazy var nameTextTitleLabel = UILabel().then {
        $0.text = "제목"
        $0.textAlignment = .right
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = UIColor(hexCode: "3177FF")
    }
    lazy var nameTextField = UITextField().then {
        $0.placeholder = "입력해 주세요."
        $0.borderStyle = .roundedRect
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    lazy var nameTextStackView = UIStackView().then {
        $0.addArrangedSubview(nameTextTitleLabel)
        $0.addArrangedSubview(nameTextField)
        $0.spacing = 16
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillProportionally
        $0.contentMode = .center
    }
    
    lazy var addButton = UIButton().then {
        $0.layer.frame = CGRect(x: 0,
                                y: 0,
                                width: Int(UIScreen.main.bounds.width / 2),
                                height: Int(UIScreen.main.bounds.height) / 13)
        $0.layer.cornerRadius = $0.layer.frame.height / 2.5
        $0.backgroundColor = UIColor(hexCode: "3177FF")
        $0.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        $0.tintColor = UIColor(hexCode: "ffffff")
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 30
        configuration.preferredSymbolConfigurationForImage =
        UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14, weight: .semibold))
        var titleAttr = AttributedString.init("Add Assets")
        titleAttr.font = .systemFont(ofSize: 18.0, weight: .semibold)
        configuration.attributedTitle = titleAttr
        $0.configuration = configuration
        $0.addTarget(self, action: #selector(saveMarkerImage), for: .touchUpInside)
    }
    
    init(markerViewModel: MarkerViewModel, markerImage: MarkerImage? = nil) {
        self.markerViewModel = markerViewModel
        self.markerImage = markerImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        setupConstraint()
        hideKeyboard()
        setTextFieldDelegate()
        toggleAddButton()
        self.navigationItem.title = "Add Assets Infomation"
    }
}

// MARK: - Configuration
extension AuthlabsAddAssetDatilViewConctroller {
    private func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        view.addGestureRecognizer(tap)
    }
}

// MARK: - UI
extension AuthlabsAddAssetDatilViewConctroller {
    func addSubviews() {
        view.addSubview(markerImageView)
        view.addSubview(buttonStackView)
        view.addSubview(nameTextStackView)
        view.addSubview(addButton)
        
    }
    
    func setupConstraint() {
        nameTextField.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width / 1.5)
            make.height.equalTo(40)
        }
        
        markerImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(UIScreen.main.bounds.width * 0.6)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.top.equalTo(markerImageView.snp.bottom).offset(10)
            make.height.equalTo(UIScreen.main.bounds.height / 15)
        }
        
        nameTextTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(40)
        }
        
        nameTextStackView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(40)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-160)
            make.width.equalTo(UIScreen.main.bounds.width / 2)
            make.height.equalTo(UIScreen.main.bounds.height / 15)
        }
    }
}

// MARK: - Methods
extension AuthlabsAddAssetDatilViewConctroller {
    private func toggleAddButton() {
        guard
            let isNameValid = nameTextField.text?.isEmpty,
            let isImageValid = markerImageView.image?.isSymbolImage
        else {
            addButton.isEnabled = false
            return
        }
        
        addButton.isEnabled = !isNameValid && !isImageValid
    }
    
    func setFields(_ markerImage: MarkerImage) {
        do {
            guard let image = UIImage(data: markerImage.data) else {
                throw NSError(domain: "image Error", code: 0)
            }
            markerImageView.image = image
            nameTextField.text = markerImage.name
        } catch {
            let okAction = UIAlertAction(title: "확인", style: .default)
            self.showMessageAlert(message: "\(error.localizedDescription)", action: [okAction])
        }
    }
}

// MARK: - @objc Methods
extension AuthlabsAddAssetDatilViewConctroller {
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func presentPhotoLibrary() {
        presentPickerViewController()
    }
    
    @objc func presentCamera() {
        presentCameraView()
    }
    
    @objc func saveMarkerImage() {
        guard
            let name = nameTextField.text,
            let image = markerImageView.image,
            let imageData = image.pngData()
        else { return }
        
        if markerImage != nil {
            markerImage?.update(
                name: name,
                data: imageData
            )
            guard let marker = markerImage else { return }
            markerViewModel.updateMarkerImage(with: marker)
        } else {
            let markerImage = MarkerImage(
                id: UUID(),
                name: name,
                data: imageData
            )
            _ = MarkerData(markerImage: markerImage, context: markerViewModel.persistentContainer.viewContext)
        }
        markerViewModel.save()
        delegate?.reloadMarkerImages()
        self.dismiss(animated: true)
    }
}

// MARK: - MarkerRegistrationViewControllerDelegate
extension AuthlabsAddAssetDatilViewConctroller: MarkerRegistrationViewControllerDelegate {
    func setImage(_ image: UIImage) {
        markerImageView.image = image
    }
}

// MARK: - UITextFieldDelegate
extension AuthlabsAddAssetDatilViewConctroller: UITextFieldDelegate {
    private func setTextFieldDelegate() {
        nameTextField.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        toggleAddButton()
        return true
    }
}

struct PreView: PreviewProvider {
    static var previews: some View {
        AuthlabsAddAssetDatilViewConctroller(markerViewModel: MarkerViewModel.shared).toPreview()
    }
}

