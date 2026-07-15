//
//  DownloadImageAsync.swift
//  SwiftConcurrencyExample
//
//  Created by Sonali Gosawi on 15/07/2026.
//

import SwiftUI
internal import Combine

class DownloadImageAsyncImageLoader {
    let url = URL(string: "https://picsum.photos/200")!
    
    func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                let image = UIImage(data: data),
                let response = response as? HTTPURLResponse,
                (200..<300).contains(response.statusCode)
            else {
                completionHandler(nil, error)
                return
            }
            completionHandler(image, nil)
        }
        .resume()
    }
}

class DownloadImageAsyncViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let loader = DownloadImageAsyncImageLoader()
    
    func fetchImage() {
        loader.downloadWithEscaping { [weak self] image, _ in
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}

struct DownloadImageAsync: View {
    @StateObject var viewModel = DownloadImageAsyncViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            viewModel.fetchImage()
        }
    }
}

#Preview {
    DownloadImageAsync()
}
