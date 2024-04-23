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
    
    lazy var photoButton = UIButton().then {

        $0.layer.frame = CGRect(x: 0,
                                y: 0,
                                width: 0,
                                height: Int(UIScreen.main.bounds.height) / 13)
        $0.layer.cornerRadius = $0.layer.frame.height / 2
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor.white.cgColor
        $0.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        $0.tintColor = .white
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 20
        configuration.preferredSymbolConfigurationForImage =
        UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14, weight: .semibold))
        var titleAttr = AttributedString.init("PHOTO")
        titleAttr.font = .systemFont(ofSize: 18.0, weight: .semibold)
        configuration.attributedTitle = titleAttr
        $0.configuration = configuration
        $0.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
    }
    
    @objc func tappedButton() {
        delegate?.moveView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupConstraint()
    }
    
    func setupConstraint() {
        view.addSubview(backgroundImage)
        view.addSubview(photoButton)
        view.addSubview(logoImage)
        
        backgroundImage.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view)
        }
        
        photoButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-140)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(UIScreen.main.bounds.width / 2)
            make.height.equalTo(UIScreen.main.bounds.height / 13)
        }
        
        logoImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

struct PreView: PreviewProvider {
    static var previews: some View {
        AuthlabsMainViewController().toPreview()
    }
}

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
