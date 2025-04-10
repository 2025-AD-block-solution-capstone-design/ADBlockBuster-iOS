//
//  ADOnboardingMainView.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/2/25.
//

import UIKit

import SnapKit

protocol ADOnboardingMainViewDelegate: AnyObject {
    func ADOnboardingMainViewDidTapNextButton(_ view: ADOnboardingMainView)
    func ADOnboardingMainViewDidChangePage(
        _ view: ADOnboardingMainView,
        currentPage: Int
    )
}

final class ADOnboardingMainView: BaseView {
    // MARK: - Properties
    weak var delegate: ADOnboardingMainViewDelegate?
    
    private let upperView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let lowerView = ADOnboardingMainLowerView()
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = Constants.numberOfItems
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .neutral
        pageControl.currentPageIndicatorTintColor = .main
        return pageControl
    }()
    
    // MARK: - Methods
    override func setupView() {
        [upperView, lowerView, pageControl].forEach(addSubview)
    }
    
    override func configure() {
        lowerView.delegate = self
        upperView.delegate = self
        upperView.dataSource = self
        upperView.isPagingEnabled = true
        upperView.showsHorizontalScrollIndicator = false
        upperView.register(OnboardingViewCell.self, forCellWithReuseIdentifier: OnboardingViewCell.reuseIdentifier)
    }
    
    override func setupLayout() {
        upperView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(safeAreaLayoutGuide).multipliedBy(LayoutConstants.half)
        }
        
        lowerView.snp.makeConstraints {
            $0.top.equalTo(upperView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(upperView.snp.bottom)
                .inset(LayoutConstants.pageControlBottomInset)
        }
    }
    
    func setLowerView(from data: OnboardingPage) {
        lowerView.setTitles(from: data)
    }
}

extension ADOnboardingMainView: ADOnboardingMainLowerViewDelegate {
    func ADOnboardingMainLowerViewDidTapNextButton(_ view: ADOnboardingMainLowerView) {
        let currentIndexPath = upperView.indexPathsForVisibleItems.first
        guard let currentItem = currentIndexPath?.item else { return }
        
        let nextIndex = currentItem + 1
        guard nextIndex < Constants.dataSource.count else {
            delegate?.ADOnboardingMainViewDidTapNextButton(self)
            return
        }
        
        let indexPath = IndexPath(item: nextIndex, section: 0)
        upperView.scrollToItem(at: indexPath, at: .right, animated: true)
        didPageChanged(nextIndex)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ADOnboardingMainView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OnboardingViewCell.reuseIdentifier,
            for: indexPath
        ) as? OnboardingViewCell else { return UICollectionViewCell() }
        
        cell.imageView.image = Constants.dataSource[indexPath.item]
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        didPageChanged(page)
    }
}

// MARK: - Private Methods
private extension ADOnboardingMainView {
    func didPageChanged(_ page: Int) {
        pageControl.currentPage = page
        delegate?.ADOnboardingMainViewDidChangePage(self, currentPage: page)
    }
}

// MARK: - Constants
private extension ADOnboardingMainView {
    enum LayoutConstants {
        static let half: CGFloat = 0.5
        static let pageControlBottomInset: CGFloat = 10
        static let nextButtonRadius: CGFloat = 12
    }
    
    enum Constants {
        static let next: String = "다음"
        static let numberOfItems: Int = 3
        static let dataSource = [
            UIImage(named: "Onboarding/Dashboard"),
            UIImage(named: "Onboarding/Update"),
            UIImage(named: "Onboarding/Reserve")
        ]
    }
}
