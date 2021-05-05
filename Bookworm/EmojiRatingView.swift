// MARK: EmojiRatingView.swift
/**
 SOURCE :
 https://www.hackingwithswift.com/books/ios-swiftui/building-a-list-with-fetchrequest
 
 Whereas the `RatingView` control can be used in any kind of project ,
 we can make a new `EmojiRatingView` that displays a rating specific to this project .
 All it will do is
 show one of five different emoji depending on the rating ,
 and it is a great example of how straightforward view composition is in SwiftUI
 — it is so easy to just pull out a small part of your views in this way .
 */

import SwiftUI


struct EmojiRatingView: View {
    
     // /////////////////
    //  MARK: PROPERTIES
    
    let rating: Int16
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var body: some View {
        
        switch rating {
        case 1 : Text("☹️")
        case 2 : Text("😒")
        case 3 : Text("😐")
        case 4 : Text("🙂")
        default : Text("🤩")
        }
    }
}





 // ///////////////
//  MARK: PREVIEWS

struct EmojiRatingView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        EmojiRatingView(rating : 3)
    }
}
