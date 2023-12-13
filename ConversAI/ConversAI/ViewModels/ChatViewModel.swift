//
//  ChatViewModel.swift
//  ConversAI
//
//  Created by Murat ÖZTÜRK on 6.06.2023.
//


import Foundation
import ChatGPTSwift
import Combine
import SwiftUI
import SQLite

class ChatViewModel: ObservableObject {
    
    let api = ChatGPTAPI(apiKey: Constants.API_KEY)
    @Published var messages = [MessageModel]()
    var role: String = ""
    var conversationId: String = ""
    var stopStream = false
    @Published var showAdsAndProVersion = false
    @Published var isGenerating: Bool = false
    @Published var freeMessageCount: Int = Constants.Preferences.FREE_MESSAGE_COUNT_DEFAULT
    var cancellables = Set<AnyCancellable>()
    var sql = SQliteDatabase()
    var currectMessageAssistant : String = ""
    
    
   
 
    func getFreeMessageCount(){
        freeMessageCount = UserDefaults.freeMessageCount
    }
    
    
    func decreaseFreeMessageCount(){
        UserDefaults.freeMessageCount -= 1
        freeMessageCount -= 1
    }
    
    
    func increaseFreeMessageCount(){
        UserDefaults.freeMessageCount += Constants.Preferences.INCREASE_COUNT
        freeMessageCount += Constants.Preferences.INCREASE_COUNT
        
    }
    
    func removeHistory(){
        api.deleteHistoryList()
        DispatchQueue.main.async {
            self.messages = [MessageModel]()
        }
    }
    
    func saveMessageToHistory(message : MessageModel){
        sql.addMessage(item: message)
    }
    
    func getMessagesHistory(){
        
        if (self.conversationId != "")
        {
            let messages = sql.getMessages(conversationIdCurrent : self.conversationId)
            var myHistoryList = [Message]()
            
            for message in messages {
                DispatchQueue.main.async {
                    
                    self.addMessage(message.content as! String, type: .text, isUserMessage: message.isUserMessage)
                    myHistoryList.append(Message(role: message.isUserMessage ? "user" : "assistant", content:message.content as! String))
                }
            }
            
            api.replaceHistoryList(with: myHistoryList)
        }
        

    }
    func stopGenerate()
    {
        stopStream = true
    }
    func getResponse(text: String) async{
        stopStream = false
        self.addMessage(text, type: .text, isUserMessage: true)
        self.addMessage("...", type: .text, isUserMessage: false)
        if self.conversationId == ""
        {
            self.conversationId = randomString(length: 5)
            
            let today = Date.now
            let formatter3 = DateFormatter()
            formatter3.dateFormat = "dd MMM yyyy - HH:mm"
            
            sql.addConversation(item: ConverstionsModel(conversationId: self.conversationId, title: text, createdAt: formatter3.string(from: today)))
            
        }
        
        
        sql.addMessage(item: MessageModel(content: text, type: .text, isUserMessage: true, conversationId: self.conversationId))
        
        do {
            DispatchQueue.main.async {
                withAnimation {
                    self.isGenerating = true
                }
                
            }
            
            // Fetch moderation asynchronously
                 let result = try await fetchModeration(inputText: text)
                 
                 if result {
                     DispatchQueue.main.async {
                         self.messages[self.messages.count - 1].content = "Your message is flagged as inappropriate. Please try again."
                         self.currectMessageAssistant = "Your message is flagged as inappropriate. Please try again."
                     }
                     sql.addMessage(item: MessageModel(content: self.currectMessageAssistant, type: .text, isUserMessage: false, conversationId: self.conversationId))

                     DispatchQueue.main.async {
                         withAnimation {
                             self.isGenerating = false
                         }
                     }
                     return
                 }
            
  
            
            
            let stream = try await api.sendMessageStream(text: text,
                                                         model: "gpt-3.5-turbo",
                                                         systemText: role,
                                                         temperature: 0.5)
            
            DispatchQueue.main.async {
                self.messages[self.messages.count - 1].content  = ""
                self.currectMessageAssistant = ""
            }
            for try await line in stream {
                DispatchQueue.main.async {
                    self.currectMessageAssistant = self.currectMessageAssistant + line
                    self.messages[self.messages.count - 1].content = self.messages[self.messages.count - 1].content as! String + line
                }
                
                if stopStream {
                    break // Stop the stream if the flag is true
                }
            }
            sql.addMessage(item: MessageModel(content: self.currectMessageAssistant, type: .text, isUserMessage: false, conversationId: self.conversationId))
            
            DispatchQueue.main.async {
                withAnimation {
                    self.isGenerating = false
                }
            }
        } catch {
            self.addMessage(error.localizedDescription, type: .error, isUserMessage: false)
        }
    }
    
    private func addMessage(_ content: Any, type: MessageType, isUserMessage: Bool) {
        DispatchQueue.main.async {
            // if messages list is empty just addl new message
            guard let lastMessage = self.messages.last else {
                let message = MessageModel(content: content, type: type, isUserMessage: isUserMessage, conversationId: self.conversationId)
                self.messages.append(message)
                return
            }
            let message = MessageModel(content: content, type: type, isUserMessage: isUserMessage, conversationId: self.conversationId)
            // if last message is an indicator switch with new one
            if lastMessage.type == .indicator && !lastMessage.isUserMessage {
                self.messages[self.messages.count - 1] = message
            } else {
                // otherwise, add new message to the end of the list
                self.messages.append(message)
            }
            
            if self.messages.count > 100 {
                self.messages.removeFirst()
            }
        }
    }
    
}


func fetchModeration(inputText: String) async throws -> Bool {
    guard let url = URL(string: "https://api.openai.com/v1/moderations") else {
        print("Invalid URL")
        return false
    }

    let headers = [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(Constants.API_KEY)"
    ]

    let parameters = ["input": inputText]

    let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = jsonData

    do {
        let (data, _) = try await URLSession.shared.data(for: request)

        let result = try JSONDecoder().decode(ModerationResult.self, from: data)

        // Check if any of the categories is flagged
        if let flagged = result.results.first?.categories.values.contains(true) {
            return flagged
        }

        return false

    } catch {
        print("Error: \(error)")
        throw error
    }
}

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}

