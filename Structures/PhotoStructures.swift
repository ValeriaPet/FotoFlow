//
//  PhotoStructure.swift
//  FotoFlow
//
//  Created by LERÄ on 18.04.24.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String?
    let welcomeDescription: String?
    let thumbImageURL: URL
    let largeImageURL: URL
    let isLiked: Bool
}

struct PhotoResult: Decodable {
    let id: String
    let width, height: Int
    let createdAt: String?
    let description, altDescription: String?
    let urls: UrlsResult
    let likes: Int
    let likedByUser: Bool
}

struct UrlsResult: Decodable {
    let raw, full, regular, small, thumb: String
}
