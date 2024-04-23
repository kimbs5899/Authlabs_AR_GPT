//
//  ChatViewModel.swift
//  Authlabs_App
//
//  Created by Matthew on 4/20/24.
//

import Foundation
import RxSwift

final class ChatBotViewModel {
    private let chatRepository: ChatRepository
    
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
    
    struct Input {
        let chatTigger: Observable<ShoesImage>
    }
    
    struct Output {
        let resultChat: Observable<Result<ResponseChatDTO, Error>>
    }
    
    func transform(input: Input) -> Output {
        let resultChat = input.chatTigger.flatMapLatest { [unowned self] image -> Observable<Result<ResponseChatDTO, Error>> in
            return self.chatRepository.requestChatResultData(image: image)
                .map {
                    return .success($0)
                }
        }.catch { error in
            return Observable.just(.failure(error))
        }
        return Output(resultChat: resultChat)
    }
}
