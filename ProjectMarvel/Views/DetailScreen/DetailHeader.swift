//
//  Created by Dustin Tong on 2/14/24.
//


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
