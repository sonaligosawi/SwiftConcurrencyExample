//
//  DoCatchTryThrowExample.swift
//  SwiftConcurrencyExample
//
//  Created by Sonali Gosawi on 11/07/2026.
//

import SwiftUI
internal import Combine

class DoCatchTryThrowExampleDataManager{
    let isActive = false
    
    func getTitle() -> (text:String?,error: Error?) {
        if isActive{
            return ("New Text!",nil)
            
        }else{
            return (nil,URLError(.badURL))
        }
        
    }
    func getTitle2()-> Result<String,Error>{
        if isActive{
            return .success("New Text")
        }else{
            return .failure(URLError(.badURL))
        }
    }
    func getTitle3() throws -> String{
        if isActive{
            return "New Text"
        }else{
            throw URLError(.appTransportSecurityRequiresSecureConnection)
        }
    }
}

class DoCatchTryThrowExampleViewModel: ObservableObject {
    
    @Published var text: String = "Starting text!"
    let manager = DoCatchTryThrowExampleDataManager()
    
    func fetchTitle(){
        let newTitle =  manager.getTitle()
        if let newTitle = newTitle.text{
            self.text = newTitle
        }else if let error = newTitle.error{
            self.text = error.localizedDescription
            
        }
        
        let result =  manager.getTitle2()
        
        switch result{
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text = error.localizedDescription
        }
        
        do {
            let newTitle = try manager.getTitle3()
            self.text = newTitle
        } catch {
            self.text = error.localizedDescription
        }
        
    }
    
}
struct DoCatchTryThrowExample: View {
    @StateObject private var viewModel = DoCatchTryThrowExampleViewModel()
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 200)
            .background(.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

#Preview {
    DoCatchTryThrowExample()
}
