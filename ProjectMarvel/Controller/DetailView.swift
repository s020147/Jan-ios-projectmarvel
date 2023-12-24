// -------------------------------------------------------------------------
// This item is the property of ResMed Ltd, and contains confidential and trade
// secret information. It may not be transferred from the custody or control of
// ResMed except as authorized in writing by an officer of ResMed. Neither this
// item nor the information it contains may be used, transferred, reproduced,
// published, or disclosed, in whole or in part, and directly or indirectly,
// except as expressly authorized by an officer of ResMed, pursuant to written
// agreement.
//
// Copyright (c) 2022 ResMed Ltd.  All rights reserved.
// -------------------------------------------------------------------------

import SwiftUI

struct DetailView: View {
    
    let character: CharacterResult
    let imageURL: URL
    var repeatedLink: String = "?ts=1&apikey=\(Environment.apiKey)\(Environment.hash)"
    var viewModel: DetailViewModel
    
    init(character: CharacterResult, imageURL: URL) {
        self.character = character
        self.imageURL = imageURL
        UINavigationBar.appearance().backgroundColor = .red
        self.viewModel = DetailViewModel(character: character)
    }
    
    var body: some View {
        ZStack() {
            Color.init(red: 0.898, green: 0.898, blue: 0.898, opacity: 0.5)
                .ignoresSafeArea()
            ScrollView {
                DetailHeader(imageURL: imageURL, character: character)
                CardGallery(character: character)
                Spacer(minLength: CGFloat(30))
                if let wikiURLString = viewModel.wikiPage {
                    HStack(alignment: .center) {
                        Button {
                            if let wikiURL = URL(string: "\(wikiURLString.replacingOccurrences(of: "http", with: "https"))\(repeatedLink)") {
                                print(wikiURL)
                                UIApplication.shared.open(wikiURL)
                            }
                        } label: {
                            Text("View full wiki page")
                                .padding()
                                .padding(.horizontal, 15)
                                .foregroundColor(Color.init(red: 173/255, green: 17/255, blue: 24/255))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.init(red: 173/255, green: 17/255, blue: 24/255), lineWidth: 1)
                                }
                        }
                    }
                }
                
            }
            .navigationTitle(character.name)
            .navigationBarColor(backgroundColor: UIColor(Color.init(red: 0.679, green: 0.068, blue: 0.093, opacity: 1)), titleColor: .white)
        }
    }
    
    struct DetailView_Previews: PreviewProvider {
        static var previews: some View {
            DetailView(character: sampleCharacter, imageURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16.jpg")!)
        }
    }
}
