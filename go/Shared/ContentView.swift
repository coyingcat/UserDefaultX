//
//  ContentView.swift
//  Shared
//
//  Created by Jz D on 2021/4/7.
//

import SwiftUI

struct ContentView: View {
    
    
    init(){

      //  UserDefaults.std.name = "one"
        
        print(UserDefaults.std.name)
        
        UserDefaults.std.name = "two"
        
        print(UserDefaults.std.name)
    }
    

    
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
