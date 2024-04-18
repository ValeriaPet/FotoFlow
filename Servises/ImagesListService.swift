//
//  ImagesListService.swift
//  FotoFlow
//
//  Created by LERÄ on 18.04.24.
//

import Foundation

final class ImagesListService {
    
    private enum photosNextPageErrors: Error {
        case requestError
    }
    
    static let imageListUpdated = Notification.Name("ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    func fetchPhotosNextPage(_ username: String, _ page: Int) {
        
        guard task == nil else {
            print("aaaa")
            return
        }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
//        let requestUrl = "https://api.unsplash.com/photos?page=\(nextPage)&per_page=10"
        
        guard let request = makeFetchListPhotoRequest(username: username, page: page) else
        {return}
        
        let session = URLSession.shared
        task = session.dataTask(with: request) { [weak self] data, response, error in
                defer { self?.task = nil }
                guard let self = self else { return }

                if let error = error {
                    print("Ошибка загрузки фото: \(error.localizedDescription)")
                    return
                }

                guard let data = data, let decodedResponse = try? JSONDecoder().decode(PhotoPageResponse.self, from: data) else {
                    print("Не удалось декодировать ответ")
                    return
                }
            
            DispatchQueue.main.async {
                decodedResponse.results.forEach { photoResult in
                    let newPhoto = Photo(
                        id: photoResult.id,
                        size: CGSize(width: CGFloat(photoResult.width), height: CGFloat(photoResult.height)),
                        createdAt: photoResult.createdAt,
                        welcomeDescription: photoResult.description,
                        thumbImageURL: photoResult.urls.thumb,
                        largeImageURL: photoResult.urls.full,
                        isLiked: false
                    )
                    self.photos.append(newPhoto)
                }
                self.lastLoadedPage = nextPage
                NotificationCenter.default.post(name: ImagesListService.imageListUpdated,
                                                object: self,
                                                userInfo: ["ImageLoaded": "Page \(nextPage)"])
            }
                
            task?.resume()
            
        }
    }
        
        func makeFetchListPhotoRequest(username: String, page: Int) -> URLRequest? {
            URLRequest.makeHTTPRequest(
                path: "/users/\(username)\(page)",
                httpMethod: "GET",
                baseURL: PhotoListUrl)
        }
    }

