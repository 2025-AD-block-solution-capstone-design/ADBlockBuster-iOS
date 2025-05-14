//
//  ADEngineType.swift
//  AD-BlockBuster
//
//  Created by 정지용 on 4/9/25.
//

enum ADEngineStatus {
    case running
    case stopped
    case undefined
}

enum ADEngineType {
    case blockEngine
    case privacyEngine
    case blockExtension
    case privacyExtension
    case whiteList
    case customEngine
}

struct ADEngineViewState {
    let ADEngineType: ADEngineType
    var ADEngineStatus: ADEngineStatus
}
