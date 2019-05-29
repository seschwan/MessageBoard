//
//  MessageThreadController.swift
//  MessageBoard
//
//  Created by Seschwan on 5/28/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import Foundation

class MessageThreadController {
    var messageThreads: [MessageThread] = []
    
    static let baseURL = URL(string: "https://lambda-message-board.firebaseio.com/")!
    
    enum HTTPMethod: String {
        case get    = "GET"
        case put    = "PUT"
        case post   = "POST"
        case delete = "DELETE"
    }
    
    func createMessageThread(title: String, completion: @escaping (Error?) -> Void) {
        let messageThread = MessageThread(title: title)
        
        let url = MessageThreadController.baseURL
        url.appendingPathComponent(messageThread.identifier)
        url.appendingPathExtension("json")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.put.rawValue
        
        let jsonEncoder = JSONEncoder()
        
        do {
            urlRequest.httpBody = try jsonEncoder.encode(messageThread)
        } catch {
            NSLog("Error encoding message thread \(error)")
        }
        
        URLSession.shared.dataTask(with: urlRequest) { ( _, _, error) in
            if let error = error {
                NSLog("Error \(error)")
                completion(error)
                return
            }
            
            self.messageThreads.append(messageThread)
            completion(nil)
        }.resume()
    }
    
    func createMessage(messageThread: MessageThread, text: String, sender: String, completion: @escaping (Error?) -> Void) {
        let newMessage = MessageThread.Message(text: text, sender: sender)
        let url = MessageThreadController.baseURL
        url.appendingPathComponent(messageThread.identifier)
        url.appendingPathComponent("messages")
        url.appendingPathExtension("json")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        
        let jsonEncoder = JSONEncoder()
        
        do {
            urlRequest.httpBody = try jsonEncoder.encode(newMessage)
        } catch {
            NSLog("Error encoding message \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (_, _, error) in
            if let error = error {
                NSLog("Error \(error)")
                completion(error)
                return
            }
            
            messageThread.messages.append(newMessage)
            completion(nil)
            
        }.resume()
    }
    
    func fetchMessagesThreads(completion: @escaping (Error?) -> Void) {
        let url = MessageThreadController.baseURL
        url.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data \(error)")
                completion(error)
                return
            }
            
            guard let data = data else { NSLog("No data returned, error"); completion(NSError()); return }
            
            let jsonDecoder = JSONDecoder()
            do {
                let messageThreadDictionaries = try jsonDecoder.decode([String: MessageThread].self, from: data)
                let messageThreads = Array(messageThreadDictionaries.values)
                completion(nil)
            } catch {
                NSLog("Unable to decode data: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
}
