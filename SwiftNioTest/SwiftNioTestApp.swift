//
//  SwiftNioTestApp.swift
//  SwiftNioTest
//
//  Created by Damiaan Twelker on 22/03/2023.
//

import SwiftUI
import AsyncHTTPClient
import Combine
import NIOHTTP1
import NIOCore
import NIOTransportServices

@main
struct SwiftNioTestApp: App {
    init() {
        test()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    func test() {
        let eventLoopGroup = NIOTSEventLoopGroup()
        let client: HTTPClient = .init(eventLoopGroupProvider: .shared(eventLoopGroup))
        
        let url = "https://www.nu.nl"
        let headers: [String:String] = [:]

        while(true) {
            var httpHeaders: HTTPHeaders = .init()
            for (key, value) in headers {
                httpHeaders.add(name: key, value: value)
            }
            let delegate = DataDelegate()
            let request: HTTPClient.Request = try! .init(url: url, method: .GET, headers: httpHeaders)
            let result = client.execute(request: request, delegate: delegate)
            result.futureResult
                .whenSuccess { progress in
                    print("Success")
                }
            result.futureResult
                .whenFailure { error in
                    print("Failure: \(error)")
            }
        }
    }
}
