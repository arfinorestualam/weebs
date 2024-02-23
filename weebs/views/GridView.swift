//
//  GridView.swift
//  weebs
//
//  Created by Arfino Alam on 23/02/24.
//

import SwiftUI

struct GridView: View {
    @StateObject private var viewModel = WeebViewModel()
    @State private var delete: WeebWifes?
    @State private var search = ""
    @State private var showAlert = false
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 100), spacing: 10)
    ]
    
    private var gridItemLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private var filter: [WeebWifes] {
        search.isEmpty ? viewModel.wife : viewModel.wife.filter {
            [$0.name, $0.anime].contains { $0.localizedCaseInsensitiveContains(search) }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if filter.isEmpty {
                    ContentUnavailableView(
                        "No results for '\(search)'",
                        systemImage: "magnifyingglass"
                    )
                } else {
                    LazyVGrid(columns: columns) {
                        ForEach(filter) { it in
                            Group {
                                VStack(alignment: .leading) {
                                    let url = URL(string: it.image)
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            waitView()
                                            
                                        case .success(let image):
                                            image.resizable().scaledToFill()
                                            
                                        case .failure( _):
                                            ZStack {
                                                Rectangle()
                                                    .foregroundStyle(Color.indigo)
                                                Image(systemName: "photo.on.rectangle.angled")
                                                    .font(.title)
                                                    .foregroundStyle(.white)
                                            }
                                            
                                        @unknown default:
                                            fatalError()
                                        }
                                    }
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    Text(it.name)
                                        .font(.system(.headline, design: .rounded, weight: .bold))
                                        .lineLimit(2, reservesSpace: true)
                                        .multilineTextAlignment(.leading)
                                    Text(it.anime)
                                        .font(.system(.caption, design: .rounded))
                                        .lineLimit(1)
                                }
                            }
                            .padding()
                            .sheet(isPresented: $viewModel.showOption) {
                                Group {
                                    let defaultText = "Just watching anime"
                                    
                                    if let imageToShare = viewModel.shareImage {
                                        ActivityView(activityItems: [defaultText, imageToShare])
                                    } else {
                                        ActivityView(activityItems: [defaultText])
                                    }
                                }
                                .presentationDetents([.medium, .large])
                            }
                            .contextMenu {
                                Button {
                                    Task {
                                        await viewModel.showSheet(from: it.image)
                                    }
                                } label: {
                                    Label("Share", systemImage: "square.and.arrow.up")
                                }
                                
                                Button {
                                    delete = it
                                    showAlert.toggle()
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Waifu")
            .task {
                await viewModel.fetch()
            }
            .refreshable {
                await viewModel.fetch()
            }
        }
        .searchable(text: $search)
        .confirmationDialog("You want to delete this?", isPresented: $showAlert, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                if let delete = delete {
                    viewModel.deleted(delete)
                }
            }
            
            Button("Cancel", role: .cancel) {
                
            }
        } message: {
            Text("This operation cannot be undone.")
        }
    }
}

//#Preview {
//    GridView()
//}

@ViewBuilder
func waitView() -> some View {
    VStack {
        ProgressView()
            .progressViewStyle(.circular)
    }
}
