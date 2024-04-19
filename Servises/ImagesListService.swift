//
//  ImagesListService.swift
//  FotoFlow
//
//  Created by LERÄ on 18.04.24.
//

import Foundation

final class ImagesListService {
    
    static let imagesListService = ImagesListService()
    var task: URLSessionTask?
    
    private enum photosNextPageErrors: Error {
        case requestError
    }
    
    static let imageListUpdated = Notification.Name(rawValue:"ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var changeLikeTask: URLSessionTask?
    
    private let photosPerPage = 10
    private let stringToDateFormatter = ISO8601DateFormatter()
    
    private init() {}
    
    func fetchPhotosNextPage(_ username: String, completion: @escaping () -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            print("aaaa")
            return
        }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let request = makeFetchListPhotoRequest(url: "\(PhotoListUrl)?page=\(nextPage)&per_page=\(photosPerPage)",
                                                    httpMethod: "GET"
        ) else {
            print("CONSOLE func fetchPhotosNextPage: Ошибка сборки запроса страницы с картинками")
            return
        }
        
        let session = URLSession.shared
        task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoPageResult], Error>) in
            guard let self = self else {return}
            self.task = nil
            switch result {
            case .success(let list):
                var newPhotosAdded = 0
                for item in list {
                    var itIsNew = true
                    if self.photos.count > 0 {
                        for oldPhoto in max(0, self.photos.count - self.photosPerPage) ..< self.photos.count {
                            if self.photos[oldPhoto].id == item.id {
                                itIsNew.toggle()
                                break
                            }
                        }
                    }
                    
                    if itIsNew {
                        guard let thumbImageURL = URL(string: item.urls.thumb),
                              let largeImageURL = URL(string: item.urls.full) else {return}
                        let newPhoto = Photo (
                            id: item.id,
                            size: CGSize(width: item.width, height: item.height),
                            createdAt: self.stringToDateFormatter.date(from: item.createdAt),
                            welcomeDescription: item.description,
                            thumbImageURL: thumbImageURL,
                            largeImageURL: largeImageURL,
                            isLiked: item.likedByUser)
                        
                        self.photos.append(newPhoto)
                        newPhotosAdded += 1
                        NotificationCenter.default.post(name: ImagesListService.imageListUpdated,
                                                        object: self,
                                                        userInfo: ["ImageLoaded": newPhoto.id])
                    }
                }
                
                self.lastLoadedPage = nextPage
                if nextPage == 1 {
                    completion()
                }
            case .failure(let error):
                print("CONSOLE func fetchPhotosNextPage:", error.localizedDescription)
                return
            }
            self.task = task
        }
        }

    func makeFetchListPhotoRequest(url: String, httpMethod: String) -> URLRequest? {

            guard let url = URL(string: url) else {
                assertionFailure("Failed to create URL")
                print("CONSOLE func makeImageServiceRequest: Ошибка сборки URL для запроса данных о фото")
                return nil
            }
            guard let token = OAuth2TokenStorage.token else {
                assertionFailure("Failed to get token from OAuth2TokenStorage")
                print("CONSOLE func makeImageServiceRequest: Ошибка получения токена от OAuth2TokenStorage")
                return nil
            }
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = httpMethod
            return request
        }
}

