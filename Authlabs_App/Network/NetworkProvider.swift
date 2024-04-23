//
//  NetworkProvider.swift
//  Authlabs_App
//
//  Created by Matthew on 4/17/24.
//

import Foundation

final class NetworkProvider {
    func makeChatNetwork() -> ChatBotNetwork {
        let network = Network<ResponseChatDTO>()
        return ChatBotNetwork(network: network)
    }
}
