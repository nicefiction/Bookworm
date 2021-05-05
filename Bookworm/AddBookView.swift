// MARK: AddBookView.swift

import SwiftUI



struct AddBookView: View {
    
     // ////////////////////////
    //  MARK: PROPERTY WRAPPERS
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var author: String = ""
    @State private var title: String = ""
    @State private var genre: String = ""
    @State private var rating: Int = 3
    @State private var review: String = ""
    // @State private var genreIndex: Int = 0
    
    
    
     // /////////////////
    //  MARK: PROPERTIES
    
    let genres: [String] = [
        "Adventure" , "Thriller" , "Fantasy" , "Horror" , "Kids" , "Mystery" , "Poetry" , "Romance"
    ]
    
    

     // /////////////////////////
    // MARK: COMPUTED PROPERTIES
    
    var body: some View {
        
        NavigationView {
            Form {
                Section {
                    TextField("Name of Book :" , text : $title)
                    TextField("Name of Author :" , text : $author)
                    Picker("Genre" , selection: $genre) {
                        ForEach(genres , id : \.self) { (genre: String) in
                            Text(genre)
                        }
                    }
                }
                Section {
//                    Picker("Rating" , selection : $rating) {
//                        ForEach(0..<6) {
//                            Text("\($0)")
//                        }
//                    }
                    RatingView(rating : $rating)
                    TextField("Write a review :" , text : $review)
                }
                HStack {
                    Spacer()
                    Button("Save Book") {
                        /**
                         Creates an instance of the `Book class`
                         using our `managed object context` ,
                         */
                        let newBook = Book(context : managedObjectContext)
                        /**
                         Copies in all the values from our form ,
                         */
                        newBook.author = self.author
                        newBook.title = self.title
                        newBook.genre = self.genre
                        newBook.rating = Int16(self.rating)
                        newBook.review = self.review
                        /**
                         Saves the managed object context .
                         */
                        try? self.managedObjectContext.save()
                        presentationMode.wrappedValue.dismiss()
                    }
                    Spacer()
                }
            }
            .navigationBarTitle(Text("Add a Book"))
        }
    }
}





 // ///////////////
//  MARK: PREVIEWS

struct AddBookView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        AddBookView()
    }
}
