// MARK: ContentView.swift
/**
 SOURCE :
 https://www.hackingwithswift.com/books/ios-swiftui/sorting-fetch-requests-with-nssortdescriptor
 */

import SwiftUI
import CoreData



struct ContentView: View {
    
     // ////////////////////////
    //  MARK: PROPERTY WRAPPERS
    /**
     When we place an object into the environment for a view ,
     it becomes accessible to that view and any views that can call it an ancestor .
     So, if we have View A that contains inside it View B ,
     anything in the environment for View A
     will also be in the environment for View B .
     Taking this a step further ,
     if View A happens to be a NavigationView ,
     any views that are pushed onto the navigation stack
     have that NavigationView as their ancestor
     so they share the same environment .
     Now think about sheets —those are full-screen pop up windows on iOS .
     Yes , one screen might have caused them to appear ,
     but does that mean the presented view can call the original its ancestor ?
     SwiftUI has an answer , and it is “no” ,
     which means that when we present a new view as a sheet
     we need to explicitly pass in a managed object context for it to use .
     As the new AddBookView will be shown as a sheet from ContentView ,
     we need to add a managed object context property to ContentView
     so it can be passed in .
     */
    @Environment(\.managedObjectContext) var managedObjectModel
    /**
     A fetch request reading all the books we have ( so we can test everything worked ) :
     */
    @FetchRequest(entity : Book.entity() ,
                  sortDescriptors : [
                    NSSortDescriptor(keyPath : \Book.title ,  ascending : true) ,
                    NSSortDescriptor(keyPath : \Book.author , ascending : true)
                    /**
                    `NOTE` :
                    You can specify more than one sort descriptor ,
                    and they will be applied in the order you provide them .
                    For example ,
                    if the user added the book “Forever” by Pete Hamill ,
                    then added “Forever” by Judy Blume
                    — an entirely different book that just happens to have the same title —
                    then specifying a second sort field is helpful .
                        Having a second or even third sort field
                    has little to no performance impact
                    unless you have lots of data with similar values .
                    */
                  ]) var books: FetchedResults<Book>
    @State private var isShowingSheet: Bool = false
    

    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(books , id : \.self) { (book: Book) in
                    NavigationLink(destination : BookDetailView(book : book)) {
                        EmojiRatingView(rating : book.rating)
                            .font(.largeTitle)
                        VStack(alignment : .leading) {
                            Text(book.author ?? "Unknown author")
                                .font(.headline)
                            Text(book.title ?? "Unknown title")
                                .font(.subheadline)
                                .foregroundColor(book.rating == 1 ? .red : .secondary)
                            /**
                             `NOTE` :
                             All the properties of our Core Data entity are optional ,
                             which means we need to make heavy use of `nil coalescing`
                             in order to make our code work .
                            */
                        }
                    }
                }
                .onDelete(perform : deleteBooks)
            }
            .navigationBarTitle(Text("Bookworm"))
            .navigationBarItems(leading : EditButton() ,
                                trailing : Button(action : {
                isShowingSheet.toggle()
            } , label : {
                Image(systemName: "plus.circle")
                    .font(.title)
            }))
            .sheet(isPresented: $isShowingSheet) {
                AddBookView().environment(\.managedObjectContext ,
                                          self.managedObjectModel)
            }
        }
    }
    
    
    
     // //////////////
    //  MARK: METHODS
    
    func deleteBooks(at offsets: IndexSet) {
        
        // books.remove(atOffsets : offsets) // This won't work in the context of Core Data .
        /**
         Rather than just removing items from an array
         we instead need to find the requested object in our fetch request
         then use it to call delete() on our managed object context .
         Once all the objects are deleted
         we can trigger another save of the context ;
         without that
         the changes won’t actually be written out to disk .
         */
        for offset in offsets {
            // STEP 1 , Find this book in our fetch request :
            let book = books[offset]
            
            // STEP 2 , Delete it from the context :
            managedObjectModel.delete(book)
        }
        // STEP 3 , Save the context :
        try? managedObjectModel.save()
    }
}





 // ///////////////
//  MARK: PREVIEWS

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ContentView()
    }
}
