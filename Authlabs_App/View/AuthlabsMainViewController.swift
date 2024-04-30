//
//  AuthlabsMainViewController.swift
//  Authlabs_App
//
//  Created by Matthew on 4/20/24.
//

import UIKit
import Then
import SnapKit
import SwiftUI

class AuthlabsMainViewController: UIViewController {
    weak var delegate: ChangeViewDelegate? = nil
    
    lazy var backgroundImage = UIImageView().then {
        $0.image = UIImage(named: "img_backPattern")
    }
    
    lazy var logoImage = UIImageView().then {
        $0.image = UIImage(named: "img_logo")
    }
    
    lazy var addAssetButton = UIButton().then {
        $0.layer.frame = CGRect(x: 0,
                                y: 0,
                                width: 0,
                                height: Int(UIScreen.main.bounds.height) / 13)
        $0.layer.cornerRadius = $0.layer.frame.height / 2
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor(hexCode: "3177FF").cgColor
        $0.setImage(UIImage(systemName: "folder.fill.badge.plus"), for: .normal)
        $0.tintColor = UIColor(hexCode: "3177FF")
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 10
        configuration.preferredSymbolConfigurationForImage =
        UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14, weight: .semibold))
        var titleAttr = AttributedString.init("Add Assets")
        titleAttr.font = .systemFont(ofSize: 18.0, weight: .semibold)
        configuration.attributedTitle = titleAttr
        $0.configuration = configuration
        $0.addTarget(self, action: #selector(tappedAddAssetButton), for: .touchUpInside)
    }
    
    lazy var scanPhotoButton = UIButton().then {
        $0.layer.frame = CGRect(x: 0,
                                y: 0,
                                width: 0,
                                height: Int(UIScreen.main.bounds.height) / 13)
        $0.layer.cornerRadius = $0.layer.frame.height / 2
        $0.backgroundColor = UIColor(hexCode: "3177FF")
        $0.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        $0.tintColor = .white
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 30
        configuration.preferredSymbolConfigurationForImage =
        UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14, weight: .semibold))
        var titleAttr = AttributedString.init("Scan AR")
        titleAttr.font = .systemFont(ofSize: 18.0, weight: .semibold)
        configuration.attributedTitle = titleAttr
        $0.configuration = configuration
        $0.addTarget(self, action: #selector(tappedScanARButton), for: .touchUpInside)
    }
    
    @objc 
    func tappedScanARButton() {
        delegate?.moveARView()
    }
    
    @objc 
    func tappedAddAssetButton() {
        delegate?.moveAddAssetsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraint()
    }
    
    func setupConstraint() {
        view.addSubview(backgroundImage)
        view.addSubview(scanPhotoButton)
        view.addSubview(logoImage)
        view.addSubview(addAssetButton)
        
        backgroundImage.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view)
        }
        
        scanPhotoButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-90)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(UIScreen.main.bounds.width / 2)
            make.height.equalTo(UIScreen.main.bounds.height / 13)
        }
        
        logoImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        addAssetButton.snp.makeConstraints { make in
            make.bottom.equalTo(scanPhotoButton.snp.top).offset(-20)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(UIScreen.main.bounds.width / 2)
            make.height.equalTo(UIScreen.main.bounds.height / 13)
        }
    }
}

//struct PreView: PreviewProvider {
//    static var previews: some View {
//        AuthlabsMainViewController().toPreview()
//    }
//}
//
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
            let viewController: UIViewController

            func makeUIViewController(context: Context) -> UIViewController {
                return viewController
            }

            func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            }
        }

        func toPreview() -> some View {
            Preview(viewController: self)
        }
}
