//
//  ContentView.swift
//  GoUserLocation
//
//  Created by Zhihui Tang on 2021/06/13.
//

import SwiftUI

struct MainView: View {
    @ObservedObject private var viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        return ZStack {
            MapView()
                .ignoresSafeArea(.all)
                .onAppear() {
                    viewModel.startLocationServices()
                    goToUserLocation()
                }
            
            VStack {
                Spacer()
                
                Button(action: {
                    goToUserLocation()
                }, label: {
                    Image(systemName: "location")
                        .font(.title2)
                        .padding(10)
                        .background(Color.primary)
                        .clipShape(Circle())
                })
                
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding()
        }
        .alert(isPresented: $viewModel.permissionDenied, content: {
            Alert(title: Text("Permission denied"),
                  message: Text("Please enable permission in App Settings"),
                  dismissButton: .default(Text("Goto Settings"),
                                          action: {
                                            print("settings url \(UIApplication.openSettingsURLString)")
                                            guard let url = URL(string: UIApplication.openSettingsURLString),
                                                  UIApplication.shared.canOpenURL(url) else {
                                                return
                                            }
                                            
                                            UIApplication.shared.open(url)
                                          }))
        })
        .environment(\.colorScheme, .dark)
    }
    
    private func goToUserLocation() {
        NotificationCenter.default.post(name: .goToCurrentLocation, object: nil)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}
