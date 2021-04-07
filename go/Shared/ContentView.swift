//
//  ContentView.swift
//  Shared
//
//  Created by Jz D on 2021/4/7.
//

import SwiftUI

struct ContentView: View {
    
    
    init(){
        // one()
        RCUserDefaults.standard.name = "前进"
        print(RCUserDefaults.standard.name)
    }
    
    
    func one(){
        RCUserDefaults.standard.string = "string"
        assert(RCUserDefaults.standard.string == "string")
        RCUserDefaults.standard.stringOptional = nil

        assert(RCUserDefaults.standard.stringOptional == nil)
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
