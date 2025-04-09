//
//  FinishNotifying.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/8/25.
//

protocol FinishNotifying {
    var onFinish: (() -> Void)? { get set }
}
