// MARK: BookDetailView.swift
/**
 SOURCE :
 https://www.hackingwithswift.com/books/ios-swiftui/showing-book-details
 */

import SwiftUI
/**
 ⭐️ `STEP 1 of 5` , Setting up Preview with Core Data :
 */
import CoreData



struct BookDetailView: View {
    
     // /////////////////
    //  MARK: PROPERTIES
    
    var book: Book
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var body: some View {
        
        GeometryReader { (geometryProxy: GeometryProxy) in
            VStack {
                // ZStack(alignment: .bottomTrailing) { // PAUL
                ZStack(alignment : Alignment(horizontal : .trailing ,
                                             vertical : .bottom) ) {
                    Image(self.book.genre ?? "Fantasy")
                        // .resizable() // OLIVIER
                        // .scaledToFit() // OLIVIER
                        .frame(maxWidth : geometryProxy.size.width)
                    Text(book.genre ?? "N/A")
                        .foregroundColor(Color.white)
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(.horizontal , 12)
                        .padding(.vertical , 5)
                        .background(Color.black.opacity(0.50))
                        .clipShape(Capsule())
                        .padding(10) // OLIVIER
                        // .offset(x: -5, y: -5) // PAUL , instead of using .padding .
                    
                }
                Text(book.title ?? "N/A")
                    .font(.title)
                    .foregroundColor(.secondary)
                Text(book.review ?? "N/A")
                    .font(.body)
                    .padding()
                RatingView(ratingByUser : .constant(Int(book.rating)))
            }
            
        }
    }
}





 // ///////////////
//  MARK: PREVIEWS

struct BookDetailView_Previews: PreviewProvider {
    
     // /////////////////
    //  MARK: PROPERTIES
    /**
     ⭐️ `STEP 2 of 5` , Setting up Preview with Core Data :
     Create a temporary managed object context  .
     Creating a managed object context
     involves telling the system
     what concurrency type we want to use .
     This is another way of saying
     _which thread do you plan to access your data using ?_
     For our example , using the main queue
     — that is the one the app was launched using — is perfectly fine :
     */
    static let managedObjectContext = NSManagedObjectContext(concurrencyType : .mainQueueConcurrencyType)
    

    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    static var previews: some View {
        /**
         ⭐️`STEP 3 of 5` , Setting up Preview with Core Data :
         Use the  temporary managed object context to create our book . Once that’s done we can pass in some example data to make our preview look good, then use the test book to create a detail view preview.
         */
        let book = Book(context : managedObjectContext)
        /**
         ⭐️`STEP 4 of 5`, Setting up Preview with Core Data :
         Once that is done
         we can pass in some example data
         to make our preview look good ,
         then use the test book to create a detail view preview .
         */
        book.author = "Some author"
        book.genre = "Fantasy"
        book.rating = 3
        book.review = "Some review"
        book.title = "Some title"
        /**
         ⭐️`STEP 5 of 5` , Setting up Preview with Core Data :
         Then use the test book
         to create a detail view preview :
         */
        return NavigationView {
            BookDetailView(book : book)
        }
    }
}
