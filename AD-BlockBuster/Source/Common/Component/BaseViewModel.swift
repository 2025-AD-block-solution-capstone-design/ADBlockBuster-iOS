//
//  BaseViewModel.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/8/25.
//

public protocol BaseViewModel {
  associatedtype Action
  associatedtype State

  var state: State { get }
  func action(_ action: Action)
}
