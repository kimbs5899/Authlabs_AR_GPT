//
//  AuthlabsAddAssetViewController.swift
//  Authlabs_App
//
//  Created by Matthew on 4/29/24.
//

import UIKit
import Then
import SnapKit
import SwiftUI

protocol MarkerImageCollectionViewControllerDelegate: AnyObject {
    func reloadMarkerImages()
}

extension AuthlabsAddAssetViewController: MarkerImageCollectionViewControllerDelegate {
    func reloadMarkerImages() {
        markerImages = markerViewModel.readAllMarkerImage()
        collectionView.reloadData()
    }
}

final class AuthlabsAddAssetViewController: UIViewController {
    weak var delegate: ChangeViewDelegate? = nil
    private let markerViewModel = MarkerViewModel.shared
    private lazy var markerImages: [MarkerImage] = markerViewModel.readAllMarkerImage()
    
    lazy var titleText = UILabel().then {
        $0.text = "Add Assets"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        $0.textAlignment = .center
        $0.textColor = .black
    }
    
    lazy var leftButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        var configuration = UIButton.Configuration.plain()
        configuration.preferredSymbolConfigurationForImage =
        UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14, weight: .semibold))
        $0.configuration = configuration
        $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    lazy var rightButton = UIButton().then {
        var configuration = UIButton.Configuration.plain()
        configuration.preferredSymbolConfigurationForImage =
        UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14, weight: .semibold))
        $0.configuration = configuration
    }
    
    lazy var titleStackView = UIStackView().then {
        $0.addArrangedSubview(leftButton)
        $0.addArrangedSubview(titleText)
        $0.addArrangedSubview(rightButton)
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
    }
    
    lazy var titleView = UIView().then {
        $0.addSubview(titleStackView)
        $0.backgroundColor = .white
        let borderLayer = CALayer()
        borderLayer.frame = CGRect(x: 0,
                                   y: 110,
                                   width: UIScreen.main.bounds.width,
                                   height: 2)
        borderLayer.backgroundColor = UIColor(hexCode: "CECECE").cgColor
        $0.layer.addSublayer(borderLayer)
    }
    
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    lazy var addButton = UIButton().then {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: UIScreen.main.bounds.width * 0.1, weight: .bold, scale: .large)
        let symbolImage = UIImage(systemName: "plus.circle.fill", withConfiguration: symbolConfiguration)
        $0.tintColor = UIColor(hexCode: "3177FF")
        $0.setImage(symbolImage, for: .normal)
        $0.addTarget(self, action: #selector(tapAddButton), for: .touchUpInside)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        setupConstraint()
        setupCollectionView()
        setupConstraint()
        addGesture()
        configureLayout()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
    }
    
    private func addGesture() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(longPressRecognizer)
    }
    
    private func presentMarkerRegistrationViewController(_ viewController: AuthlabsAddAssetDatilViewConctroller) {
        viewController.delegate = self
        present(viewController, animated: true)
    }
    
    private func showDeleteConfirmation(for indexPath: IndexPath) {
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let id = self?.markerImages[indexPath.item].id else { return }
            self?.markerViewModel.deleteMarkerImage(by: id)
            self?.reloadMarkerImages()
        }
        
        let alert = UIAlertController(title: nil, message: "마커를 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func tapAddButton() {
        let authlabsAddAssetDetailViewController = AuthlabsAddAssetDatilViewConctroller(markerViewModel: markerViewModel)
        presentMarkerRegistrationViewController(authlabsAddAssetDetailViewController)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: point) {
                showDeleteConfirmation(for: indexPath)
            }
        }
    }
    
    func addSubviews() {
        view.addSubview(titleView)
        view.addSubview(addButton)
        view.addSubview(collectionView)
        view.bringSubviewToFront(addButton)
    }
    
    func setupConstraint() {
        addButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-30)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        titleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(110)
        }
        
        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.bottom.equalTo(titleView)
        }
        
        titleText.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width - 40)
        }
        
        leftButton.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.centerY.equalTo(titleText)
            make.trailing.equalTo(titleText.snp.leading).offset(-10)
        }
        
        rightButton.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.centerY.equalTo(titleText)
            make.leading.equalTo(titleText.snp.trailing).offset(10)
        }
    }
    
    private func configureLayout() {
        let screenWidth = view.safeAreaLayoutGuide.layoutFrame.width
        let numberOfItemsPerRow = 3
        let spacing: CGFloat = 2
        let totalSpacing = (CGFloat(numberOfItemsPerRow - 1) * spacing)
        let width = (screenWidth - totalSpacing) / CGFloat(numberOfItemsPerRow)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        collectionView.collectionViewLayout = layout
    }
    
    @objc
    func backButtonTapped() {
        delegate?.moveMainView()
    }
}

extension AuthlabsAddAssetViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return markerImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        let imageView = UIImageView(frame: cell.bounds)
        imageView.contentMode = .scaleToFill
        
        let markerImage = markerImages[indexPath.item]
        
        if let image = UIImage(data: markerImage.data) {
            imageView.image = image
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
        
        cell.contentView.addSubview(imageView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let markerImage = markerImages[indexPath.item]
        let authlabsAddAssetDetailViewController = AuthlabsAddAssetDatilViewConctroller(markerViewModel: markerViewModel, markerImage: markerImage)
        authlabsAddAssetDetailViewController.setFields(markerImage)
        presentMarkerRegistrationViewController(authlabsAddAssetDetailViewController)
    }
}
