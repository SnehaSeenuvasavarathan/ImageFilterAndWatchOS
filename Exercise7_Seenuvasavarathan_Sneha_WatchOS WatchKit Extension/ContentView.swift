//
//  ContentView.swift
//  Exercise7_Seenuvasavarathan_Sneha_WatchOS WatchKit Extension
//
//  Created by Sneha Seenuvasavarathan on 11/7/22.
//

//import SwiftUI
//
//struct ContentView: View {
//    @ObservedObject var model = ViewModelWatch()
//    var body: some View {
//        Image(systemName: "photo.artframe")
//                        .imageScale(.large)
//                        .foregroundColor(.accentColor)
//        Text(model.messageText)
//        Image(uiImage: model.messageImg!)
//            .padding()
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

import SwiftUI

struct ContentView: View {
    @ObservedObject var model = ViewModelWatch()
    var body: some View {
        VStack {
            Image(systemName: "photo.artframe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(model.messageText)
            Image(uiImage: model.messageImg!)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
