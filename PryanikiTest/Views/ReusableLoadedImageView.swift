//
//  LoadedImageView.swift
//  PryanikiTest
//
//  Created by Николаев Никита on 30.01.2021.
//

import UIKit

class ReusableLoadedImageView: UIImageView {
    static let imageCache = NSCache<NSURL, UIImage>()
    var task: URLSessionTask!
    
    func loadImage(from url: URL) {
        image = nil
        if let task = task {
            task.cancel()
        }
        if let imageFromCache = ReusableLoadedImageView.imageCache.object(forKey: url as NSURL) {
            image = imageFromCache
            return
        }
        task = URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data,
                  let newImage = UIImage(data: data) else { return }
            ReusableLoadedImageView.imageCache.setObject(newImage, forKey: url as NSURL)
            DispatchQueue.main.async {
                self.image = newImage
            }
        }
        task.resume()
    }
}
