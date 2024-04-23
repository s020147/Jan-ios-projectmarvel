//
//  Created by Dustin Tong on 2/14/24.
//


import SwiftUI

struct NameCard: View {
    let character: CharacterResult
    
    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .strokeBorder(.black, lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 25).fill(.white))
                .frame(width: geometry.size.width, height: geometry.size.width * 0.3)
                .overlay(
                    VStack(alignment: .leading) {
                        Text("Name")
                            .fontWeight(.medium)
                            .font(.system(size: 16))
                        Text("\(character.name)").fontWeight(.semibold)
                            .font(.system(size: 24))
                            .foregroundColor(Color.init( red: 66/255, green: 66/255, blue: 67/255))
                    }
                )
        }
    }
}

struct NameCard_Previews: PreviewProvider {
    static var previews: some View {
        NameCard(character: sampleCharacter)
    }
}
