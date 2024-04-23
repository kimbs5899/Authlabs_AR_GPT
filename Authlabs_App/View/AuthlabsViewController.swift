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

    let disposeBag = DisposeBag()
    fileprivate let nodeTrigger = PublishSubject<ShoesImage>()
    
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
        
        
        let configuration = ARImageTrackingConfiguration()
        guard
            let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Image", bundle: Bundle.main)
        else {
            return
        }
        
        configuration.trackingImages = imageToTrack
        configuration.maximumNumberOfTrackedImages = 1
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
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
            makeModel(on: planeNode, name: ShoesImage(rawValue: imageName) ?? ShoesImage.NikeAirForce0)
        }
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedNode))
//        node.addGestureRecognizer(<#T##UIGestureRecognizer#>)
        
        return node
    }
    
//    @objc
//    func tappedNode() {
//        print("클릭함")
//    }
    
    func setupSceneView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.sceneView.addGestureRecognizer(tapGesture)
    }

    @objc
    func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self.sceneView)
        let hitTestResults = self.sceneView.hitTest(location, options: nil)
        
        if let firstResult = hitTestResults.first, firstResult.node.name == "NIKE" {
            print("Node tapped")
            bindView()
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
        let text = SCNText(string: "Nike Air 1 Force Low Sketch", extrusionDepth: 1)
        text.font = UIFont.systemFont(ofSize: 11.0)
        label.geometry = text

        label.simdPivot.columns.3.x = Float((text.boundingBox.min.x +
                                             text.boundingBox.max.x) / 2)

        label.simdPivot.columns.3.y = Float((text.boundingBox.min.y +
                                             text.boundingBox.max.y) / 2)

        label.scale = SCNVector3(0.0003, 0.0003, 0.0003)
        label.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        planeNode.addChildNode(label)
        planeNode.name = "NIKE"
        return planeNode
    }
    
    fileprivate func makeModel(on planeNode: SCNNode, name: ShoesImage) {
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
            .bind { result in
                switch result {
                case .success(let data):
                    print("======\(data.choices[0].message.content)")
                case .failure(let error):
                    let okAction = UIAlertAction(title: "확인", style: .default)
                    self.showMessageAlert(message: "\(error.localizedDescription)", action: [okAction])
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bindView() {
        guard
            let userImage = ShoesImage(rawValue: "NikeAirForce0")
        else {
            return
        }
        self.nodeTrigger.onNext(userImage)
    }
}
