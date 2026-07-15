//
//  DownloadImageAsync.swift
//  SwiftConcurrencyExample
//
//  Created by Sonali Gosawi on 15/07/2026.
//

import SwiftUI
internal import Combine

class DownloadImageAsyncViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    
    func fetchImage(){
        self.image = UIImage(systemName:"heart.fill")
    }
}

struct DownloadImageAsync: View {
    @StateObject var viewModel = DownloadImageAsyncViewModel()
    var body: some View {
        ZStack{
            if let image = viewModel.image{
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
            .onAppear{
                viewModel.fetchImage()
            }
        }
    }

#Preview {
    DownloadImageAsync()
}
