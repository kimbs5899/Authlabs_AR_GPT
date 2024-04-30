//
//  AuthlabsDetailViewController.swift
//  Authlabs_App
//
//  Created by Matthew on 4/24/24.
//

import UIKit
import Then
import SnapKit

class AuthlabsARDetailViewController: UIViewController {
    var viewModel: DetailViewModel
    
    lazy var similarTitleText = UILabel().then {
        $0.text = "유사도"
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.layer.opacity = 6.0
        $0.textAlignment = .center
        $0.textColor = UIColor(hexCode: "264F8C")
    }
    
    lazy var similarNumberText = UILabel().then {
        $0.text = "--%"
        $0.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = UIColor(hexCode: "2544EA")
    }
    
    lazy var detilInforText = UILabel().then {
        $0.text = "--"
        $0.textAlignment = .left
        $0.layer.opacity = 8.0
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = UIColor(hexCode: "5F667D")
        $0.numberOfLines = 10
    }
    
    lazy var circleImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.isUserInteractionEnabled = true
    }
    
    lazy var similarStackView = UIStackView().then {
        $0.addArrangedSubview(similarTitleText)
        $0.addArrangedSubview(similarNumberText)
        $0.axis = .vertical
        $0.alignment = .center
    }
    
    lazy var infoView = UIView().then {
        $0.addSubview(self.circleImageView)
        $0.addSubview(self.similarStackView)
    }
    
    lazy var imageList: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 30, height: UIScreen.main.bounds.width / 2 - 30)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return view
    }()
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        imageListRegister()
        view.addSubview(infoView)
        view.addSubview(imageList)
        view.addSubview(detilInforText)
        setupConstraint()
        imageList.dataSource = viewModel.dataSource
        self.navigationItem.title = viewModel.resultData.baseImage
        configure(data: viewModel.resultData)
        setupCircleAnimation()
    }
    
    func setupCircleAnimation() {
        guard
            let gifURL = Bundle.main.url(forResource: "img_circle", withExtension: "gif"),
            let gifData = try? Data(contentsOf: gifURL),
            let source = CGImageSourceCreateWithData(gifData as CFData, nil)
        else { return }
        
        let frameCount = CGImageSourceGetCount(source)
        var images = [UIImage]()
        
        (0..<frameCount)
            .compactMap { CGImageSourceCreateImageAtIndex(source, $0, nil) }
            .forEach { images.append(UIImage(cgImage: $0)) }
        
        circleImageView.animationImages = images
        circleImageView.animationDuration = TimeInterval(frameCount) * 0.05
        circleImageView.animationRepeatCount = 0
        circleImageView.startAnimating()
    }
    
    func setupConstraint() {
        circleImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(200)
        }

        similarStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        detilInforText.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
        }

        infoView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(100)
            make.centerX.equalToSuperview()
        }
        
        imageList.snp.makeConstraints { make in
            make.top.equalTo(detilInforText.snp.bottom).offset(30)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(30)
        }
    }
    
    func imageListRegister() {
        self.imageList.register(SearchImageCell.self, forCellWithReuseIdentifier: SearchImageCell.identifier)
    }
    
    func configure(data: ChatResultData) {
        self.similarNumberText.text = data.similarity
        self.detilInforText.text = data.detailInfomation
    }
}



class SearchImageCell:  UICollectionViewListCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    private let imageView = UIImageView().then {
        $0.image = UIImage(systemName: "photo.fill")
        $0.tintColor = .white
        $0.backgroundColor = .lightGray
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 20.0
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViews() {
        self.addSubview(imageView)
    }
    
    func configure(image: UIImage) {
        imageView.image = image
    }
}

enum Section: Equatable {
    case main
}
