// MARK: ContentView.swift

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
     SwiftUI has an answe r, and it is “no” ,
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
                  sortDescriptors : []) var books: FetchedResults<Book>
    @State private var isShowingSheet: Bool = false
    

    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var body: some View {
        
        NavigationView {
            Text("Count : \(books.count)")
                .navigationBarTitle(Text("Bookworm"))
                .navigationBarItems(trailing : Button(action : {
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
}





 // ///////////////
//  MARK: PREVIEWS

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
//        ContentView().environment(\.managedObjectContext ,
//                                  PersistenceController.preview.container.viewContext)
        ContentView()
    }
}
