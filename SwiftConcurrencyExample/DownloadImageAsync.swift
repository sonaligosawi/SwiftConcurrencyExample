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
    func handleResponse(data: Data?,response: URLResponse?)-> UIImage?{
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            (200..<300).contains(response.statusCode)
        else {
            
            return nil
        }
        return image
    }
    func downloadWithAsync() async throws -> UIImage?{
        do{
            let (data,response) = try await URLSession.shared.data(from: url, delegate: nil)
            return handleResponse(data: data, response: response)
            
        }catch {
            throw error
        }
        
    }
    func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
            let image = self?.handleResponse(data: data, response: response)
            completionHandler(image, error)
        }
        .resume()
    }
}

class DownloadImageAsyncViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let loader = DownloadImageAsyncImageLoader()
    
    func fetchImage()async {
        //        loader.downloadWithEscaping { [weak self] image, _ in
        //            DispatchQueue.main.async {
        //                self?.image = image
        //            }
        //        }
        let image = try? await loader.downloadWithAsync()
       await MainActor.run(body: {
            self.image = image
        })
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
            Task{
                await viewModel.fetchImage()
            }
        }
    }
}

#Preview {
    DownloadImageAsync()
}
