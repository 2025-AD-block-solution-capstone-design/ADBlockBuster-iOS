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
                title: "대시보드 시작하기",
                description: "대시보드를 시작해요",
                buttonTitle: "다음"
            ),
            OnboardingPage(
                title: "업데이트 활용하기",
                description: "엔진을 최신화해요",
                buttonTitle: "다음"
            ),
            OnboardingPage(
                title: "예비",
                description: "일단킵",
                buttonTitle: "홈으로 가기"
            )
        ]
    }
}

