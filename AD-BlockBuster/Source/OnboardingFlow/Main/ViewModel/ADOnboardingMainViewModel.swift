//
//  ADOnboardingMainViewModel.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/8/25.
//

import Foundation
import UIKit

final class ADOnboardingMainViewModel: BaseViewModel {
    // MARK: - Properties
    enum Action {
        case pageChanged(Int)
    }
    
    struct State {
        var currentPage: Int
        var title: String
        var description: String
        var buttonTitle: String
    }
    
    @Published var state: State
    
    // MARK: - Initialize
    init() {
        state = State(
            currentPage: 0,
            title: Constants.pages[0].title,
            description: Constants.pages[0].description,
            buttonTitle: Constants.pages[0].buttonTitle
        )
    }
    
    // MARK: - Methods
    func action(_ action: Action) {
        switch action {
        case .pageChanged(let currentPage):
            updateState(by: currentPage)
        }
    }
}

// MARK: - Private Methods
private extension ADOnboardingMainViewModel {
    func updateState(by currentPage: Int) {
        guard currentPage >= 0 && currentPage < Constants.pages.count else { return }
        state.currentPage = currentPage
        state.title = Constants.pages[currentPage].title
        state.description = Constants.pages[currentPage].description
        state.buttonTitle = Constants.pages[currentPage].buttonTitle
    }
}

// MARK: - Constants
private extension ADOnboardingMainViewModel {
    enum Constants {
        static let pages: [OnboardingPage] = [
            OnboardingPage(
                title: "엔진 적용하기",
                description: "설정 - 앱 - Safari에서 엔진을 활성화해요",
                buttonTitle: "다음"
            ),
            OnboardingPage(
                title: "엔진 설정하기",
                description: """
                CSSBlockEngine을 활성화하고,
                권한 - 모든 웹사이트에서 허용으로 변경해요
                """,
                buttonTitle: "시작하기"
            )
        ]
    }
}

