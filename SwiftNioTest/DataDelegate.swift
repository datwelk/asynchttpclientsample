//
//  DataDelegate.swift
//  SwiftNioTest
//
//  Created by Damiaan Twelker on 22/03/2023.
//

import Foundation
import AsyncHTTPClient
import Combine
import NIOHTTP1
import NIOCore
import NIOTransportServices

class DataDelegate: HTTPClientResponseDelegate {
    typealias Response = Data

    var data: [UInt8] = []
    var statusCode: Int = 0
    
    var totalBytes: Int {
        return data.count
    }

    func didSendRequestHead(task: HTTPClient.Task<Response>, _ head: HTTPRequestHead) {}

    func didSendRequestPart(task: HTTPClient.Task<Response>, _ part: IOData) {}

    func didSendRequest(task: HTTPClient.Task<Response>) { }
    
    func didReceiveError(task: HTTPClient.Task<Response>, _ error: Error) {}

    func didReceiveHead(
        task: HTTPClient.Task<Response>,
        _ head: HTTPResponseHead
    ) -> EventLoopFuture<Void> {
        self.statusCode = Int(head.status.code)
        return task.eventLoop.makeSucceededFuture(())
    }

    func didReceiveBodyPart(
        task: HTTPClient.Task<Response>,
        _ buffer: ByteBuffer
    ) -> EventLoopFuture<Void> {
        if let bytes = buffer.getBytes(at: buffer.readerIndex, length: buffer.readableBytes) {
            data += bytes
        }
        return task.eventLoop.makeSucceededFuture(())
    }

    func didFinishRequest(task: HTTPClient.Task<Response>) throws -> Data {
        return Data(data)
    }
}
