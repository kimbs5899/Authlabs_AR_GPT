//
//  ChatBotNetwork.swift
//  Authlabs_App
//
//  Created by Matthew on 4/17/24.
//

import Foundation
import RxSwift

final class ChatBotNetwork {
    private let network: Network<ResponseChatDTO>
    
    init(network: Network<ResponseChatDTO>) {
        self.network = network
    }
}

// MARK: - Public Method
extension ChatBotNetwork {
    func requestChatBotImage(image: ShoesImage) -> Observable<ResponseChatDTO> {
        return network.fetchData(image: ShoesImage(rawValue: encodeImage(imageName: image.name)!) ?? .NikeAirForce0)
    }
}

// MARK: - Private Method
private extension ChatBotNetwork {
    func encodeImage(imageName: String) -> String? {
        guard let image = UIImage(named: imageName) else {
            return nil
        }
        
        guard let imageData = image.pngData() else {
            return nil
        }
        return imageData.base64EncodedString()
    }
}
