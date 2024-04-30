//
//  ViewController.swift
//  Authlabs_App
//
//  Created by Matthew on 4/17/24.
//

import UIKit
import ARKit
import AVFoundation
import SnapKit
import RxSwift
import RxCocoa

class AuthlabsARViewController: UIViewController, ARSessionDelegate {
    weak var delegate: ChangeViewDelegate? = nil
    lazy var sceneView = ARSCNView()
    let viewModel: ChatBotViewModel
    private var session: ARSession {
        return sceneView.session
      }
    var searchImage: String? = nil
    let disposeBag = DisposeBag()
    fileprivate let nodeTrigger = PublishSubject<AssetsImage>()
    var dataSource: UICollectionViewDiffableDataSource<Section, UIImage>!
    
    init(viewModel: ChatBotViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = sceneView
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        setupSceneView()
        bindViewModel()
        startAR()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAR()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.pause()
    }
    
    func startAR() {
        let configuration = ARImageTrackingConfiguration()
        guard
            let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Image", bundle: Bundle.main)
        else {
            return
        }
        configuration.trackingImages = imageToTrack
        configuration.maximumNumberOfTrackedImages = 2
        sceneView.session.run(configuration)
    }
}

extension AuthlabsARViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        guard 
            let imageAnchor = anchor as? ARImageAnchor
        else {
            return node
        }
        
        let planeNode = detectCard(at: imageAnchor)
        
        node.addChildNode(planeNode)
        
        if let imageName = imageAnchor.referenceImage.name {
            if imageName == "qrcode" || imageName == "starbucks" {
                return node
            } else {
                makeModel(on: planeNode, name: AssetsImage(rawValue: imageName)!)
            }
        }
        return node
    }
    
    func setupSceneView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGesture)
    }

    @objc
    func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self.sceneView)
        let hitTestResults = self.sceneView.hitTest(location, options: nil)
        
        if let firstResult = hitTestResults.first, firstResult.node.name == "Marker" {
            LoadingIndicatorView.showLoading(in: self.view)
            UIApplication.shared.beginIgnoringInteractionEvents()
            guard 
                let image = self.searchImage
            else {
                print("Error Not Found Serach Image")
                return
            }
            bindView(image: AssetsImage(rawValue: image)!)
        }
    }
    
    func detectCard(at imageAnchor: ARImageAnchor) -> SCNNode {
        let imageSize = imageAnchor.referenceImage.physicalSize
        let rootNode = SCNPlane(width: 0.05, height: 0.01)
        rootNode.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.9)
        rootNode.cornerRadius = 0.01

        let planeNode = SCNNode(geometry: rootNode)
        let zOffset = imageSize.height / 1.5

        planeNode.position = SCNVector3(0, 0, zOffset)
        planeNode.eulerAngles.x = -(Float.pi / 2)
        
        let label = SCNNode()
        let text = SCNText(string: imageAnchor.referenceImage.name, extrusionDepth: 1)
        self.searchImage = imageAnchor.referenceImage.name
        text.font = UIFont.systemFont(ofSize: 11.0)
        label.geometry = text

        label.simdPivot.columns.3.x = Float((text.boundingBox.min.x +
                                             text.boundingBox.max.x) / 2)

        label.simdPivot.columns.3.y = Float((text.boundingBox.min.y +
                                             text.boundingBox.max.y) / 2)

        label.scale = SCNVector3(0.0003, 0.0003, 0.0003)
        label.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        planeNode.addChildNode(label)
        planeNode.name = "Marker"
        return planeNode
    }
    
    fileprivate func makeModel(on planeNode: SCNNode, name: AssetsImage) {
        guard
            let shoesScene = SCNScene(named: name.assetLocation)
        else {
            return
        }
        guard
            let shoesNode = shoesScene.rootNode.childNodes.first
        else {
            return
        }
        shoesNode.scale = SCNVector3(0.2, 0.2, 0.2)
        planeNode.addChildNode(shoesNode)
    }
}

private extension AuthlabsARViewController {
    func bindViewModel() {
        let input = ChatBotViewModel.Input(chatTigger: nodeTrigger)
        let output = viewModel.transform(input: input)
        output.resultChat
            .observe(on: MainScheduler.instance)
            .bind { resultData in
                switch resultData {
                case .success(let data):
                    let resultData = self.transformResponseData(from: data.choices[0].message.content)
                    DispatchQueue.main.async {
                        let detailViewModel = DetailViewModel(resultData: resultData)
                        let detail = AuthlabsARDetailViewController(viewModel: detailViewModel)
                        detailViewModel.configureDataSource(imageList: detail.imageList)
                        self.present(UINavigationController(rootViewController: detail), animated: true) {
                            LoadingIndicatorView.hideLoading(in: self.view)
                            UIApplication.shared.endIgnoringInteractionEvents()
                        }
                    }
                case .failure(let error):
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    self.showMessageAlert(message: "\(error.localizedDescription)", action: [okAction])
                }
            }
            .disposed(by: disposeBag)
    }
    
    func transformResponseData(from message: String) -> ChatResultData {
        var baseImage = ""
        var similarity = ""
        var description = ""
        var keywords: [String] = []
        
        let lines = message.components(separatedBy: "\n")
        for line in lines {
           let parts = line.components(separatedBy: ":").map { $0.trimmingCharacters(in: .whitespaces) }
           guard parts.count == 2 else { continue }
           let key = parts[0]
           var value = parts[1]
           value = value.replacingOccurrences(of: "'", with: "")
           switch key {
           case "베이스이미지":
               baseImage = value
           case "유사도":
               similarity = value
           case "키워드":
               let keywordList = value.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
               keywords = keywordList
           case "설명":
               description = value
           default:
               break
           }
        }
        return ChatResultData(baseImage: baseImage, similarity: similarity, detailInfomation: description, keywords: keywords)
    }
    
    func bindView(image: AssetsImage) {
        self.nodeTrigger.onNext(image)
    }
}
