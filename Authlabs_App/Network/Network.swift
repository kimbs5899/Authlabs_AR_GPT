//
//  Network.swift
//  Authlabs_App
//
//  Created by Matthew on 4/17/24.
//

import RxSwift
import RxAlamofire
import Foundation

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
    
    func fetchSearchImageData(with urlRequest: URLRequest) async throws -> (Result<Data, NetworkError>) {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            return handleDataTaskCompletion(data: data, response: response)
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
    
    func handleDataTaskCompletion(
        data: Data?,
        response: URLResponse?
    ) -> (Result<Data, NetworkError>) {
        guard
            let httpResponse = response as? HTTPURLResponse
        else {
            return .failure(.invalidResponseError)
        }
        
        return self.handleHTTPResponse(
            data: data,
            httpResponse: httpResponse
        )
    }
    
    func handleHTTPResponse(
        data: Data?,
        httpResponse: HTTPURLResponse
    ) -> (Result<Data, NetworkError>) {
        guard
            let data = data
        else {
            return .failure(.noDataError)
        }
        switch httpResponse.statusCode {
        case 300..<400:
            return .failure(.redirectionError)
        case 400..<500:
            return .failure(.clientError)
        case 500..<600:
            return .failure(.serverError)
        default:
            return .success(data)
        }
    }
}
