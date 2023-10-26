//
//  UIImageExtension.swift
//  RickMortyUI
//
//  Created by Joao Matheus on 25/10/23.
//

import UIKit

extension UIImageView {

    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("\(error)")
                completion(nil)
                return
            }

            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                completion(nil)
            }
        }
        task.resume()
    }

}
