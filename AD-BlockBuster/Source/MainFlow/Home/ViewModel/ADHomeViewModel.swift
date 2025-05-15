//
//  ADHomeViewModel.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/9/25.
//

import Foundation

final class ADHomeViewModel: BaseViewModel {
    enum Action {
        case fetchStates
    }
    
    struct State {
        var engines: [ADEngineViewState]
    }
    
    @Published var state: State
    
    init() {
        self.state = State(engines: [])
    }
    
    func action(_ action: Action) {
        switch action {
        case .fetchStates:
            // TODO: UseCase 구현
            return
        }
    }
}
