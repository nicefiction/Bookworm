// MARK: RatingView.swift
/**
 SOURCE :
 https://www.hackingwithswift.com/books/ios-swiftui/adding-a-custom-star-rating-component
 
 SwiftUI makes it really easy to create custom UI components ,
 because they are effectively just views
 that have some sort of `@Binding` exposed for us to read .
 */

import SwiftUI



struct RatingView: View {
    
     // ////////////////////////
    //  MARK: PROPERTY WRAPPERS
    /**
     We also need a property to store an `@Binding` integer ,
     so we can report back the user’s selection to whatever is using the star rating .
     */
    @Binding var rating: Int
    
    
    
     // ////////////////
    // MARK: PROPERTIES
    
    var label: String = ""
    var maximumRating: Int = 5
    /**
     The off and on images dictate the images to use when the star is highlighted or not :
     DEFAULT : `nil` for the `offImage` , and a filled star for the `onImage` ;
     if we find `nil` in the `offImage` we’ll use the`onImage`there too .
     */
    // var offImage: Image? OLIVIER : Sorry Paul , I don't think this is necessary .
    var onImage: Image = Image(systemName: "star.fill")
    var offColor: Color = Color.gray
    var onColor: Color = Color.yellow
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var body: some View {
        
        HStack {
            if label.isEmpty == false {
                Text(label)
            }
            ForEach(1..<maximumRating + 1) { (ratingNumber: Int) in
                // self.image(for : ratingNumber) // PAUL
                onImage // OLIVIER
                    .foregroundColor(ratingNumber > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = ratingNumber
                    }
            }
        }
    }
    

        
     // //////////////
    //  MARK: METHODS
    
    func image(for ratingInput: Int)
    -> Image {
        
        // return (ratingInput > rating) ? (offImage ?? onImage) : onImage // OLIVIER
        
        if ratingInput > rating {
            //return offImage ?? onImage
            return onImage // OLIVIER : This works as well . Why the need for an optional offImage ?
            
        } else {
            return onImage
        }
    } // PAUL
}





 // ///////////////
//  MARK: PREVIEWS

struct RatingView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        RatingView(rating: .constant(3))
        /**
         `Constant bindings` are bindings that have fixed values ,
         which on the one hand means they can’t be changed in the UI ,
         but also means we can create them trivially — they are perfect for previews .
         */
    }
}
