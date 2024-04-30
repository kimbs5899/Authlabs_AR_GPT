# **🔍 What is this Project?**

### AI활용 iOS 앱 개발자 부트캠프 채용형 미니인턴 - 오스랩스

AR 활용 이미지 인식·검출·추적·증강 및 ChatGPT API 활용 이미지 검색·결과출력 기능 개발 - 김병수

# **🏆 Challenge**

1. 마커 등록
    
    
    |  | Printed Image | 2D Image | Real Object |
    | --- | --- | --- | --- |
    | QRCode | X | X | X |
    | Text | X | X | X |
    | Image | X | X | X |
2. 마커 인식 / 검출 / 추적
    
    
    |  | Printed Image | 2D Image | Real Object |
    | --- | --- | --- | --- |
    | QRCode | O | O | O |
    | Text | O | O | O |
    | Image | O | O | O |
3. 콘텐츠 증강
    
    
    |  | Printed Image | 2D Image | Real Object |
    | --- | --- | --- | --- |
    | QRCode | O | O | O |
    | Text | O | O | O |
    | Image | O | O | O |
4. 이미지 검색
    
    
    |  | Printed Image | 2D Image | Real Object |
    | --- | --- | --- | --- |
    | QRCode | O | O | O |
    | Text | O | O | O |
    | Image | O | O | O |
5. 정확도 분석
    
    
    |  | Printed Image | 2D Image | Real Object |
    | --- | --- | --- | --- |
    | QRCode | O | O | O |
    | Text | O | O | O |
    | Image | O | O | O |
6. 결과 출력
    
    
    |  | Printed Image | 2D Image | Real Object |
    | --- | --- | --- | --- |
    | QRCode | O | O | O |
    | Text | O | O | O |
    | Image | O | O | O |
- [x]  **ARKit**
1. Image Tracking 
    (이미지 트랙킹)
2. Image Scanning 
    (이미지 스캐닝)
3. 3D Modeling 
    (3D 모델링)
- [x]  **Chat GPT**
1. Image Recognition 
    (이미지 인식)
2. Image Similarity Checking 
    (이미지 유사도 확인)
3. Image Keyword Extraction 
    (이미지 키워드 출력)
- [x]  **Web Search**
1. Web Search with Specific Keywords 
    (키워드 웹 검색)
2. Web Fetch Network Image
    (웹 이미지 네트워크 통신)

# **📱 UI&UX App Design**

![Group 238](https://github.com/kimbs5899/Authlabs_AR_GPT/assets/130636633/90d58d8f-175d-4dab-9dd9-986a67362dd9)

# **📷 ScreenShot**

![ezgif com-video-to-gif-converter](https://github.com/kimbs5899/Authlabs_AR_GPT/assets/130636633/7e13a12e-d9f6-4485-b2a5-a3b6e54ffd89)


# **✅ Checklist**

- `**ARKit**` 활용
`ARKit`을 활용하여 증강현실 프레임워크로
카메라 기능을 통한 위치 추적, 표면 감지, 조명 및 환경 매핑과 같은 기능을 사용하여 사용자에게 증강 현실 경험을 제공
- **`ARSCNView`**란?
`ARSCNView`는 `UIKit`, `SceneKit` 프레임워크의 통합된 클래스이고 기본적으로 화면에 실시간 카메라 영상을 표시하고 그 위에 `SceneKit`을 사용하여 `3D` 객체나 오브젝트를 표시하고 사용
- **`SCNNode`**란?
`SceneKit` 프레임워크에서 사용되는 기본적인 클래스로 `3D` 공간에서 객체로 사용 `3D` 공간에서의 위치, 회전, 크기 및 변환 등 속성을 가질 수 있고 부모-자식 관계를 통해 복잡한 `3D` 오브젝트 구현이 가능
    
    ```swift
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
    ```
    
- **`RxSwift`**를 활용한 **`Network`** 비동기 통신
`RxSwift`의 특정 이벤트를 `Trigger`로 `RxAlamofire`를 통한 비동기 네트워크 통신을 구현했으며, 추가적인 비동기 네트워크 통신에 사용하기 위한 `Setup` 작업에 활용
    
    ```swift
    class Network<T: Codable> {
        private let queue: ConcurrentDispatchQueueScheduler
        
        init() {
            self.queue = ConcurrentDispatchQueueScheduler(qos: .background)
        }
        
        func fetchData(image: AssetsImage) -> Observable<T> {
            let urlRequest = NetworkURL.makeURLRequest(type: .chatGPT, chat: RequestChatDTO(messages: [
                Message(content: [
                    Content(type: "text",
                            text: """
                                  안녕하세요.
                                  당신은 이미지 매칭 머신입니다.
                                  
                                  1번째 이미지는 기준 이미지입니다.
                                  1번째 이미지의 타이틀을 지어 베이스이미지에 넣고,
                                  2번째 이미지와 비교하여 유사도랑 비슷한 키워드를 3개 출력하고, 간략한 설명을
                                  아래와 같은 형식으로 출력해주시길 바랍니다.
                                  
                                  형식
                                  베이스이미지: ''
                                  유사도: nn%
                                  키워드: '@@', '@@', '@@'
                                  설명: ''
                                  """,
                            imageURL: nil),
    
                    Content(type: "image_url", text: nil, imageURL: ImageURL(url: encodeImage(imageName: AssetsImage(rawValue: image.name)?.rawValue ?? ""))),
                    Content(type: "image_url", text: nil, imageURL: ImageURL(url: encodeImage(imageName: image.name)))
                ])
            ]), httpMethod: .post)!
            let result = RxAlamofire.requestData(urlRequest)
                .observe(on: queue)
                .debug()
                .map { (response, data) -> T in
                    return try JSONDecoder().decode(T.self, from: data)
                }
            return result
        } 
    }
    
    private extension Network {
        func encodeImage(imageName: String) -> String {
            guard let image = UIImage(named: imageName) else {
                return ""
            }
            
            guard let imageData = image.pngData() else {
                return ""
            }
            return "data:image/jpeg;base64,\(imageData.base64EncodedString())"
        }
    }
    ```
    
- **`MVVM`** 적용
    
    ```swift
    ├── Animation - 20240429.json
    ├── App
    │   ├── AppDelegate.swift
    │   └── SceneDelegate.swift
    ├── Extension+
    │   ├── Bundle+Extension.swift
    │   ├── UIColor+Extension.swift
    │   └── UIViewController+Extension.swift
    ├── Info.plist
    ├── Model
    │   ├── AssetsImage.swift
    │   ├── ChatResultData.swift
    │   ├── JSONNull.swift
    │   ├── MarkerImage.swift
    │   ├── RequestChatDTO.swift
    │   ├── RequestImageSearch.swift
    │   └── ResponseChatDTO.swift
    ├── Network
    │   ├── APIType.swift
    │   ├── ChatBotNetwork.swift
    │   ├── HttpMethod.swift
    │   ├── Network.swift
    │   ├── NetworkError.swift
    │   ├── NetworkProvider.swift
    │   └── NetworkURL.swift
    ├── NikeAirForce1.scn
    ├── Resource
    │   ├── APIToken.plist
    │   ├── Assets.xcassets
    │   │   ├── AccentColor.colorset
    │   │   │   └── Contents.json
    │   │   ├── AppIcon.appiconset
    │   │   │   ├── App_Icon2x.png
    │   │   │   └── Contents.json
    │   │   ├── Contents.json
    │   │   ├── Image.arresourcegroup
    │   │   │   ├── Contents.json
    │   │   │   ├── NikeAirForce0.arreferenceimage
    │   │   │   │   ├── Contents.json
    │   │   │   │   └── NikeAirForce0.jpg
    │   │   │   ├── NikeAirForce1.arreferenceimage
    │   │   │   │   ├── Contents.json
    │   │   │   │   └── NikeAirForce1.jpg
    │   │   │   ├── NikeAirForce2.arreferenceimage
    │   │   │   │   ├── Contents.json
    │   │   │   │   └── NikeAirForce10.jpg
    │   │   │   ├── NikeAirForce3.arreferenceimage
    │   │   │   │   ├── Contents.json
    │   │   │   │   └── NikeAirForce11.jpg
    │   │   │   ├── NikeAirForce4.arreferenceimage
    │   │   │   │   ├── Contents.json
    │   │   │   │   └── NikeAirForce5.jpg
    │   │   │   ├── NikeAirForce5.arreferenceimage
    │   │   │   │   ├── Contents.json
    │   │   │   │   └── NikeAirForce8.jpg
    │   │   │   ├── qrcode.arreferenceimage
    │   │   │   │   ├── Contents.json
    │   │   │   │   └── qrcode.png
    │   │   │   └── starbucks.arreferenceimage
    │   │   │       ├── Contents.json
    │   │   │       └── starbucks.png
    │   │   ├── TestIamge1.imageset
    │   │   │   ├── Contents.json
    │   │   │   └── TestIamge1.png
    │   │   ├── TestImage2.imageset
    │   │   │   ├── Contents.json
    │   │   │   └── TestImage2.jpeg
    │   │   ├── img_addAssets_isEmpty.imageset
    │   │   │   ├── Contents.json
    │   │   │   └── img_addAssets_isEmpty.png
    │   │   ├── img_backPattern.imageset
    │   │   │   ├── Contents.json
    │   │   │   ├── img_backPattern.png
    │   │   │   ├── img_backPattern2x.png
    │   │   │   └── img_backPattern3x.png
    │   │   ├── img_circle.imageset
    │   │   │   ├── Contents.json
    │   │   │   └── img_circle.png
    │   │   └── img_logo.imageset
    │   │       ├── Contents.json
    │   │       ├── img_logo.png
    │   │       ├── img_logo2x.png
    │   │       └── img_logo3x.png
    │   ├── MarkerData+CoreDataClass.swift
    │   ├── MarkerData+CoreDataProperties.swift
    │   └── MarkerData.xcdatamodeld
    │       └── MarkerData.xcdatamodel
    │           └── contents
    ├── View
    │   ├── AuthlabsARDetailViewController.swift
    │   ├── AuthlabsARViewController.swift
    │   ├── AuthlabsAddAssetDatilViewConctroller+Extension.swift
    │   ├── AuthlabsAddAssetDatilViewConctroller.swift
    │   ├── AuthlabsAddAssetViewController.swift
    │   ├── AuthlabsMainViewController.swift
    │   ├── Base.lproj
    │   │   └── LaunchScreen.storyboard
    │   └── LoadingIndicatorView.swift
    ├── ViewModel
    │   ├── ChatRepository.swift
    │   ├── ChatViewModel.swift
    │   ├── DetailViewModel.swift
    │   ├── MarkerProvider.swift
    │   └── MarkerViewModel.swift
    └── img_circle.gif
    ```
    
- `**UICollectionViewDiffableDatasource**` 활용
`ViewModel`을 따로 만들어 실제 데이터가 변경되면 `ViewModel`을 통해 `View`로 전달
`MVVM` 패턴을 활용하여 `View`와 `ViewModel`을 분리하여 `DiffableDataSource`를 적용
    
    ```swift
    final class DetailViewModel {
        var images: [UIImage] = []
        var resultData: ChatResultData
        var dataSource: UICollectionViewDiffableDataSource<Section, UIImage>!
        var snapshot: NSDiffableDataSourceSnapshot<Section, UIImage>!
        
        init(resultData: ChatResultData) {
            self.resultData = resultData
            Task {
                do {
                    let result = try await kakaoImageSearch(keyword: resultData.keywords)
                    switch result {
                    case .success(let data):
                        await downloadImages(from: data.documents.map{ $0.imageURL })
                        applyInitialSnapshot(data: self.images)
                    case .failure(let failure):
                        print("Kakao image search error: \(failure)")
                    }
    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        func applyInitialSnapshot(data: [UIImage]) {
            snapshot = .init()
            snapshot.appendSections([.main])
            snapshot.appendItems(data, toSection: .main)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
        
        func configureDataSource(imageList: UICollectionView) {
            dataSource = UICollectionViewDiffableDataSource<Section, UIImage>(
                collectionView: imageList,
                cellProvider: { collectionView,indexPath,itemIdentifier in
                    guard
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchImageCell.identifier, for: indexPath)
                            as? SearchImageCell
                    else {
                        return UICollectionViewCell()
                    }
                    cell.configure(image: self.images[indexPath.row])
                    return cell
                })
            imageList.allowsSelection = false
            applyInitialSnapshot(data: self.images)
        }
    }
    ```
    
- **`Snapshot`** 적용
대부분의 뷰를 `Then`과 `SnpaShot`을 통해 `init, AutoLayout` 구현했습니다.
그 과정에서 `CollectionView`를 생성할때 `Then`을 제대로 활용하지 못한 점과 `CustomNavigator`를 만들때 오토레이아웃 오류를 잡지 못한 점이 아쉬웠습니다. 보다 더 확실히 공부하여`AutoLayout`을 설정해 보겠습니다.

# **🚨Troubleshooting**

- **`ARKit Configuration**
ARWorldTrackingConfiguration` vs `ARImageTrackingConfiguration
****`원래는 라이브러리에서 가져온 이미지와 사진 촬영한 이미지를 코어데이터 저장하고 그걸 마커로 ARKit을 활용할 예정이었습니다.
그러나 아쉽게도 라이브러리에서 가져온 이미지, 사진 촬영 이미지를 코어데이터에 저장했지만
그걸 마커로 등록하는것에는 실패했습니다. 기존 로직에서 ARKit Configuration은`ARImageTrackingConfiguration` ****을 사용했지만 코어데이터의 이미지를 가져오기 위해서는 `ARWorldTrackingConfiguration` ****을 사용해야한다고 찾았습니다. 기존 로직과 코어데이터를 사용하는 로직 둘다 구현하고 싶었지만 그건 아쉽게 방법을 찾지 못했습니다.
이후 조금더 `ARKit Configuration`에 대해 찾아보고 알아보는 계기가 되었습니다.
- **`Web Crawling**
GPT`를 통해 가져온 결과값을 통해 URL을 생성하고 해당 `html`에서 `Web crawling`을 통해 이미지를 가져올 계획이었습니다. 그러나 최근 네이버, 구글, 다음 등에서 `Web crawling`을 막아둔 것을 발견했습니다. 그래서 이번에 결국 `SwiftSoup`에 대한 활용을 못하고 `Kakao Search API`를 적용하여 이미지를 검색하고 받아와 컬렉션뷰에 표시도록 로직을 수정했습니다.
보다 정확한 이미지 퀄리티를 위하여 `Web crawling`을 더 찾아봐서 잘 활용하는 계기가 되었습니다.
- **`UICollectionViewDiffableDataSource`**
`UICollectionViewDiffableDataSource`는 기존 `UICollectrionViewDataSource`와 다르게 `MVVM`에서 더 효율적으로 사용할 수 있었습니다. `View`와 `ViewModel`을 분리하여 각각의 활용도를 최대한 높이고 이를 통해 좀더 `MVVM` 패턴을 이해하는 계기가 되었습니다.
