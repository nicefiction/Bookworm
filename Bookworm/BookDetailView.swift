// MARK: BookDetailView.swift
/**
 SOURCE :
 ⭐️ https://www.hackingwithswift.com/books/ios-swiftui/showing-book-details
 
 💥 https://www.hackingwithswift.com/books/ios-swiftui/using-an-alert-to-pop-a-navigationlink-programmatically

 We are going to add one last feature to our app
 that deletes whatever book the user is currently looking at .
 To do this
 we need to show an alert asking the user if they really want to delete the book ,
 then delete the book from the current managed object context
 if that is what they want .
 Once that is done ,
 there is no point staying on the current screen
 because its associated book doesn’t exist any more ,
 so we are going to pop the current view
 — remove it from the top of the NavigationView stack ,
 so we move back to the previous screen .
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
    
    
    
     // ////////////////////////
    //  MARK: PROPERTY WRAPPERS
    
    /**
     💥 STEP 1 of , Programmatic Alert :
     A property to hold our Core Data managed object context
     so we can delete stuff .
     */
    @Environment(\.managedObjectContext) var managedObjectContext
    /**
     💥 STEP 2 of , Programmatic Alert :
     A property to hold our presentation mode
     so we can pop the view off the navigation stack .
     */
    @Environment(\.presentationMode) var presentationMode
    /**
     💥 STEP 3 of , Programmatic Alert :
     A property to control whether we are showing the delete confirmation alert or not .
     */
    @State private var isShowingDeleteAlert: Bool = false
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var formattedDate: String {
        
//        let dateComponents =
//            Calendar.current.dateComponents([.day , .month , .year] ,
//                                            from : book.date ?? Date())
//
//        let dateDay = dateComponents.day ?? 1
//        let dateMonth = dateComponents.month ?? 1
//        let dateYear = dateComponents.year ?? 0
//
//        return "\(dateDay) / \(dateMonth) / \(dateYear)"
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        let timeString = timeFormatter.string(from : book.date ?? Date())
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        let dateString = dateFormatter.string(from : book.date ?? Date())
        
        return "\(dateString) at \(timeString)"
    }
    
    
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
                        // .offset(x: -5, y: -5) // PAUL , instead of using .padding
                    
                }
                Text(book.title ?? "N/A")
                    .font(.title)
                    .foregroundColor(.secondary)
                Text(book.review ?? "N/A")
                    .font(.body)
                    .padding()
                // Text("\(book.date ?? Date())")
                Text(formattedDate)
                    .padding(.horizontal)
                    .foregroundColor(Color.secondary)
                RatingView(ratingByUser : .constant(Int(book.rating)))
                    .padding()
            }
            .navigationBarItems(trailing : Button(action: {
                isShowingDeleteAlert = true
            }, label : {
                Image(systemName: "trash")
                    .font(.title)
            }))
            .alert(isPresented: $isShowingDeleteAlert) {
                Alert(title : Text("Delete \(book.title ?? "N/A")") ,
                      message : Text("Are you sure ?") ,
                      primaryButton : .destructive(Text("Delete") ,
                                                   action : deleteBook) ,
                      secondaryButton : .cancel(Text("Cancel")))
            }
        }
    }
    
    
    
     // //////////////
    //  MARK: METHODS
    /**
     💥 STEP 4 of , Programmatic Alert :
     Write a method that
     deletes the current book from our managed object context ,
     and dismisses the current view .
     */
    func deleteBook() {
        
        managedObjectContext.delete(book)
        try? managedObjectContext.save()
        presentationMode.wrappedValue.dismiss()
        /**
         `NOTE` :
         It doesn’t matter that this view is being shown using a navigation link rather than a sheet
         — we still use the same `presentationMode.wrappedValue.dismiss()` code .
         */
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
        book.date = Date()
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
