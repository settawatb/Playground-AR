//
//  AsyncImage.swift
//  Playground_AR
//
//  Created by Settawat B. on 18/2/2567 BE.
//

import Foundation
import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private var cancellable: AnyCancellable?

    init(url: URL?) {
        guard let url = url else { return }
        self.loadImage(from: url)
    }

    deinit {
        cancellable?.cancel()
    }

    func loadImage(from url: URL) {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .handleEvents(receiveCancel: {
                self.cancellable?.cancel()
            })
            .replaceError(with: UIImage(named: "image_placeholder")?.pngData() ?? Data())
            .eraseToAnyPublisher()
            .compactMap { data in UIImage(data: data) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.image = image
            }
    }
}


