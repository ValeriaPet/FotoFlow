//
//  PhotoStructure.swift
//  FotoFlow
//
//  Created by LERÄ on 18.04.24.
//

import Foundation

struct Photo {
    var id: String
    var size: CGSize
    var createdAt: Date?
    var welcomeDescription: String?
    var thumbImageURL: URL
    var largeImageURL: URL
    var isLiked: Bool
}

struct PhotoPageResult: Decodable {
    let id: String
    let width, height: Int
    let createdAt: String
    let description, altDescription: String?
    let urls: UrlsResult
//    let likes: Int
    let likedByUser: Bool
}

struct PhotoPageResponse: Decodable {
    let results: [PhotoPageResult]
}
struct UrlsResult: Decodable {
    let full: String
    let thumb: String
}
