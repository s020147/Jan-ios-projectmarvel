//
//  Created by Dustin Tong on 2/14/24.
//


import SwiftUI

struct SeriesView: View {
    var destination: URL?
    
    init(destination: String) {
        let secureDestination = destination.replacingOccurrences(of: "http", with: "https")
        self.destination = URL(string: secureDestination)
    }
    
    @StateObject private var viewModel = SeriesViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(viewModel.seriesList, id: \.id) { item in
                    LazyVStack {
                        HStack(alignment: .center) {
                            Text(item.title)
                                .font(.headline)
                            if (item.resultDescription == nil || item.resultDescription == "") {
                                Text("No Description Available")
                                    .font(.caption)
                                    .foregroundColor(Color.init(red: 66/255, green: 66/255, blue: 67/255))
                            } else {
                                Text(item.resultDescription!)
                                    .font(.caption)
                                    .foregroundColor(Color.init(red: 66/255, green: 66/255, blue: 67/255))
                            }
                        }
                        .padding(7)
                        .onAppear(perform: {
                            if viewModel.shouldLoadMoreContent(currentSeries: item),
                               let destination = destination {
                                viewModel.loadData(urlString: destination.absoluteString)
                            }
                        })
                        
                        GeometryReader() { geometry in
                            Divider()
                                .frame(width: geometry.size.width, height: 2)
                                .overlay(Color(red: 173/255, green: 17/255, blue: 24/255, opacity: 1))
                        }
                    }
                }
            }
            .onAppear() {
                if let destination = destination {
                    viewModel.loadData(urlString: destination.absoluteString)
                }
            }
        }
        .navigationTitle("Series")
    }
}

struct SeriesView_Previews: PreviewProvider {
    static var previews: some View {
        SeriesView(destination:  "http://gateway.marvel.com/v1/public/characters/1009146/series?ts=1&apikey=80927809fe13da055e5477a0996093c7&hash=f25bfb7addb67f49a3479a1baf232a01")
    }
}
