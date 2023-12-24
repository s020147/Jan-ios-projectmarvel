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
struct DetailHeader: View {
    let imageURL: URL
    let character: CharacterResult
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            AsyncImage(
                url: imageURL,
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                },
                placeholder: {
                    ProgressView()
                })
            GeometryReader { geometry in
                NameCard(character: character)
                    .frame(width: geometry.size.width * 0.85, height: geometry.size.height * 0.1, alignment: .leading)
                    .offset(x: geometry.size.width * 0.075)
                    .padding(.bottom, -150)
            }.offset(y: -70)
            
            if character.resultDescription != "" {
                Text("Bio")
                    .foregroundColor(Color.init(red: 66/255, green: 66/255, blue: 67/255))
                    .fontWeight(.semibold)
                    .padding()
                Text(character.resultDescription)
                    .foregroundColor(Color.init(red: 66/255, green: 66/255, blue: 67/255))
                    .padding(.horizontal)
                    .padding(.bottom)
            } else {
                Text("No Bio Available")
                    .foregroundColor(Color.init(red: 66/255, green: 66/255, blue: 67/255))
                    .fontWeight(.semibold)
                    .padding()
            }
            
            HStack {
                Spacer()
                Divider()
                    .frame(width: 140, height: 2)
                    .overlay(.black)
                Spacer()
            }
        }
    }
}

struct DetailHeader_Previews: PreviewProvider {
    static var previews: some View {
        DetailHeader(imageURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16.jpg")!, character: sampleCharacter)
    }
}
