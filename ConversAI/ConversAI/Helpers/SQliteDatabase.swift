//
//  SQliteDatabase.swift
//  ConversAI
//
//  Created by Murat ÖZTÜRK on 8.06.2023.
//


import SwiftUI
import SQLite

class SQliteDatabase {
    private let db: Connection
    
    init() {
        let fileManager = FileManager.default
        let documentsDirectory = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let databaseURL = documentsDirectory.appendingPathComponent("db.sqlite3")
        db = try! Connection(databaseURL.path)
        
        createConversationsTable()
        createMessagesTable()
    }
    
    
    private func createConversationsTable() {
        do {
            let conversations = Table("conversations")
            let id = Expression<Int>("id")
            let conversationId = Expression<String>("conversationId")
            let title = Expression<String>("title")
            let createdAt = Expression<String>("createdAt")
            
            try db.run(conversations.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(conversationId)
                t.column(title)
                t.column(createdAt)
            })
            
            
        } catch {
            print("createConversationsTable \(error)" )
        }
    }
    
    private func createMessagesTable() {
        do {
            let messages = Table("messages")
            let id = Expression<Int>("id")
            let conversationId = Expression<String>("conversationId")
            let content = Expression<String>("content")
            let isUserMessage = Expression<Bool>("isUserMessage")
            
            
            try db.run(messages.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(conversationId)
                t.column(content)
                t.column(isUserMessage)
            })
            
            
        } catch {
            print(error)
        }
    }
    
    func getConversations() -> [ConverstionsModel] {
        var list = [ConverstionsModel]()
        
        let conversations = Table("conversations")
        let conversationId = Expression<String>("conversationId")
        let id = Expression<Int>("id")
        let title = Expression<String>("title")
        let createdAt = Expression<String>("createdAt")
        
        do {
            for conversation in try db.prepare(conversations) {
                let conversationModel = ConverstionsModel(id: conversation[id],conversationId : conversation[conversationId], title: conversation[title], createdAt: conversation[createdAt])
                list.append(conversationModel)
            }
        } catch {
            print(error)
        }
        
        return list
    }
    
    func getMessages(conversationIdCurrent : String) -> [MessageModel] {
        var list = [MessageModel]()
        
        let messages = Table("messages")
        _ = Expression<Int>("id")
        let conversationId = Expression<String>("conversationId")
        let content = Expression<String>("content")
        let isUserMessage = Expression<Bool>("isUserMessage")
        
        let messagesNew = messages.filter(conversationId == conversationIdCurrent)
        
        
        do {
            for message in try db.prepare(messagesNew) {
                let messagesModel = MessageModel(content: message[content], type: .text, isUserMessage: message[isUserMessage], conversationId: message[conversationId])
                list.append(messagesModel)
            }
        } catch {
            print(error)
        }
        
        return list
    }
    
    func addConversation(item: ConverstionsModel) {
        let conversations = Table("conversations")
        let conversationId = Expression<String>("conversationId")
        let title = Expression<String>("title")
        let createdAt = Expression<String>("createdAt")
        
        let insert = conversations.insert(conversationId <- item.conversationId, title <- item.title,createdAt <- item.createdAt)
        
        do {
            try db.run(insert)
        } catch {
            print(error)
        }
    }
    func addMessage(item: MessageModel) {
        let messages = Table("messages")
        _ = Expression<UUID>("id")
        let conversationId = Expression<String>("conversationId")
        let content = Expression<String>("content")
        let isUserMessage = Expression<Bool>("isUserMessage")
        
        let insert = messages.insert(conversationId <- item.conversationId, content <- item.content as! String ,isUserMessage <- item.isUserMessage)
        do {
            try db.run(insert)
        } catch {
            print(error)
        }
    }
    
    func deleteConversation(conversationId: String) {
        let conversations = Table("conversations")
        let messages = Table("messages")
        let conversationIdSQL = Expression<String>("conversationId")
        
        
        let conversationsNew = conversations.filter(conversationIdSQL == conversationId)
        let messagesNew = messages.filter(conversationIdSQL == conversationId)
        
        do {
            try db.run(conversationsNew.delete())
            try db.run(messagesNew.delete())
        } catch {
            print(error)
        }
        
    }
    
    func deleteAllConversations() {
        let conversations = Table("conversations")
        let messages = Table("messages")
        
        do {
            try db.run(conversations.delete())
            try db.run(messages.delete())
        } catch {
            print(error)
        }
        
    }
    
}
