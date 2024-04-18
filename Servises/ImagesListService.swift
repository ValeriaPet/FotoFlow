//
//  ImagesListService.swift
//  FotoFlow
//
//  Created by LERÄ on 18.04.24.
//

import Foundation

final class ImagesListService {
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    
    func fetchPhotosNextPage() {
        
        let nextPage = (lastLoadedPage ?? 0) + 1
    }
}
