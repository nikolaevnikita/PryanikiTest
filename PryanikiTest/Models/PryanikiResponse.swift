//
//  PryanikiResponse.swift
//  PryanikiTest
//
//  Created by Николаев Никита on 30.01.2021.
//

import Foundation

// MARK: - Pryaniki Response
struct PryanikiResponse: Decodable {
    let data: [DataBlock]
    let view: [String]
}

// MARK: - Data Block
struct DataBlock: Decodable {
    let name: String
    let data: Content
}

// MARK: - Content
struct Content: Decodable {
    let text: String?
    let url: String?
    let selectedId: Int?
    let variants: [Variant]?
}

// MARK: - Variant
struct Variant: Decodable {
    let id: Int
    let text: String
}
