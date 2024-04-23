//
//  Network.swift
//  Authlabs_App
//
//  Created by Matthew on 4/17/24.
//

import RxSwift
import RxAlamofire
import Foundation

class Network<T: Decodable> {
    private let queue: ConcurrentDispatchQueueScheduler
    
    init() {
        self.queue = ConcurrentDispatchQueueScheduler(qos: .background)
    }
    
    func fetchData(image: ShoesImage) -> Observable<T> {
        let urlRequest = NetworkURL.makeURLRequest(type: .chatGPT, chat: RequestChatDTO(messages: [
            Message(content: [
                Content(type: "text", text: "hi You are an image matching machine. Please send me the similarity of the second image and 3 keywords based on the first image I sent. The format is Similarity: n% keyword : '@@', '@@', '@@'", imageURL: nil),
                Content(type: "image_url", text: nil, imageURL: ImageURL(url: encodeImage(imageName: image.name))),
                Content(type: "image_url", text: nil, imageURL: ImageURL(url: encodeImage(imageName: image.name))),
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
