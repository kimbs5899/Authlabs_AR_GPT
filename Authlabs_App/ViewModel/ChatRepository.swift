//
//  ChatRepository.swift
//  Authlabs_App
//
//  Created by Matthew on 4/20/24.
//

import Foundation
import RxSwift

struct ChatRepository {
    private let chatBotNetwork: ChatBotNetwork
    
    init(provider: NetworkProvider) {
        self.chatBotNetwork = provider.makeChatNetwork()
    }
    
    func requestChatResultData(image: AssetsImage) -> Observable<ResponseChatDTO> {
        self.chatBotNetwork.requestChatBotImage(image: image).map {
            return $0
        }
    }
}
