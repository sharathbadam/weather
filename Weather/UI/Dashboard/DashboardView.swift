//
//  ContentView.swift
//  Weather
//
//  Created by Sharath on 10/10/24.
//

import SwiftUI

struct DashboardView: View {
    
    @ObservedObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            // Search Back
            searchBar
            Spacer()

            // Show weather view aafter the search
            if let weather = viewModel.weather {
                WeatherReportView(weatherReport: weather)
                    .padding()
            }
        }
        .background(Color(.background))
        .onAppear {
            viewModel.requestLocationPermission()
        }
    }
    
    var searchBar: some View {
        VStack(alignment: .center, spacing: 0.0) {
            HStack(spacing: 8.0) {
                // Search Bar
                TextField(NSLocalizedString("search_placeholder", comment: ""), text: $viewModel.searchQuery)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .accessibilityLabel(NSLocalizedString("search_placeholder", comment: ""))
                    .popover(isPresented: $viewModel.showPopover, content: {
                        // List Dropdown List for Search Results
                        VStack(alignment: .leading) {
                            Group {
                                Text(NSLocalizedString("search_result", comment: "")).font(.largeTitle).accessibilityLabel(NSLocalizedString("search_result", comment: ""))+Text(viewModel.searchQuery).font(.largeTitle).accessibilityLabel(viewModel.searchQuery)
                            }
                            .padding()
                            List(viewModel.searchResults, id: \.id) { item in
                                searchItem(item: item)
                            }
                            .listStyle(PlainListStyle())
                            .padding()
                            Spacer()
                        }
                        
                    })
                        
                // Button: Current Location
                Button {
                    viewModel.requestLocationPermission()
                } label: {
                    Image(.location)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                }
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if let errorMsg = viewModel.errorMsg {
                Text(errorMsg)
                    .padding()
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            
        }
        .padding()
    }
    
    //Search result View
    func searchItem(item: GeoCode) -> some View {
        HStack(alignment: .center) {
            Image(.location)
                .resizable()
                .scaledToFit()
                .frame(width: 35, height: 35)

            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                    .accessibilityLabel(item.name)
                Text("\(item.state ?? "") \(item.country ?? "")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .accessibilityLabel("\(item.state ?? "") \(item.country ?? "")")
            }
        }
        .onTapGesture {
            viewModel.selectLocation(location: item)
        }
    }
}

#Preview {
    DashboardView()
}
