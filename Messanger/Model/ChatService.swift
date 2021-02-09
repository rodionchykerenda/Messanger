//
//  ChatService.swift
//  Messanger
//
//  Created by Rodion on 3/21/19.
//  Copyright © 2019 Rodion. All rights reserved.
//

import Foundation
import Scaledrone

protocol ChatServiceDelegate: class {
    func didDecryptMessage(message: String)
}

class ChatService{
    private let scaledrone: Scaledrone
    private let messageCallback: (Message) -> Void
    
    private var room: ScaledroneRoom?
    private var currentUsers: [ScaledroneMember] = []
    private var currentUser: User
    
    private weak var delegate: ChatServiceDelegate?
    
    init(member: User, onRecievedMessage: @escaping (Message)-> Void) {
        self.currentUser = member
        self.messageCallback = onRecievedMessage
        self.scaledrone = Scaledrone(
            channelID: "yDjBvdCIONUKsTAQ",
            data: member.toJSON)
        scaledrone.delegate = self
    }
    
    func setDelegate(delegate: ChatServiceDelegate) {
        self.delegate = delegate
    }
    
    func connect() {
        scaledrone.connect()
    }
    
    func disconnect(){
        scaledrone.disconnect()
    }
    
    func sendMessage(message:String){
        if message == "Sender" {
            UserManager.shared.becomeSender(state: true)
        } else if message.contains("&") {
            let text = String(message.dropFirst())
            let encryptedMessage = UserManager.shared.encrypt(message: text)
            room?.publish(message: encryptedMessage)
            return
        } else if message.contains("#") {
            if let value = Int(String(message.dropFirst())) {
                UserManager.shared.setPublicKey(value: value)
                room?.publish(message: message)
                return
            }
            room?.publish(message: UserManager.shared.sendPublicKey())
            return
        } else if message == "|" {
            room?.publish(message: UserManager.shared.sendPartialKey())
            return
        } else if message.contains("?") {
            let value = Int(String(message.dropFirst()))!
            UserManager.shared.setPrivateKey(value: value)
            return
        }
        room?.publish(message: message)
    }
}

//MARK: - Scaledrone delegate
extension ChatService: ScaledroneDelegate{
    func scaledroneDidConnect(scaledrone: Scaledrone, error: NSError?) {
        room = scaledrone.subscribe(roomName: "observable-room")
        room?.delegate = self
        room?.observableDelegate = self
    }
    
    func scaledroneDidReceiveError(scaledrone: Scaledrone, error: NSError?) {
        print("Scaledrone error", error ?? "")
    }
    
    func scaledroneDidDisconnect(scaledrone: Scaledrone, error: NSError?) {
        print("Scaledrone disconnected", error ?? "")
    }
}

//MARK: - Room delegate
extension ChatService: ScaledroneRoomDelegate {
    func scaledroneRoomDidConnect(room: ScaledroneRoom, error: NSError?) {
        debugPrint("Connected to room!")
    }
    
    func scaledroneRoomDidReceiveMessage(room: ScaledroneRoom, message: Any, member: ScaledroneMember?) {
        guard let text = message as? String, let memberData = member?.clientData, let member = User(fromJSON: memberData) else {
            return
        }
        let message = Message(user: member, messageText: text, messageID: UUID().uuidString)
        messageCallback(message)
        
        if member.name != self.currentUser.name {
            if message.messageText == "Sender" {
                UserManager.shared.becomeSender(state: false)
            } else if message.messageText.contains("#") {
                let number = message.messageText.dropFirst()
                let value = Int(number)
                UserManager.shared.setExternalPublicKey(value: value!)
            } else if message.messageText.contains("|") {
                let number = message.messageText.dropFirst()
                let value = Int(number)
                UserManager.shared.setPartialKey(value: value!)
            } else {
                let decryptedMessage = UserManager.shared.decrypt(message: message.messageText)
                delegate?.didDecryptMessage(message: decryptedMessage)
            }
        }
    }
}

//MARK: - Observable room delegate
extension ChatService: ScaledroneObservableRoomDelegate{
    
    func scaledroneObservableRoomDidConnect(room: ScaledroneRoom, members: [ScaledroneMember]) {
        currentUsers = members
        NotificationCenter.default.post(name: .StartUserAmount, object: nil)
    }
    
    func scaledroneObservableRoomMemberDidJoin(room: ScaledroneRoom, member: ScaledroneMember) {
        newUserJoined(member: member)
    }
    
    func scaledroneObservableRoomMemberDidLeave(room: ScaledroneRoom, member: ScaledroneMember) {
        userLeftChat(member: member)
    }
    
}

//MARK: - Methods for getting current users` list
extension ChatService{
    
    //MARK: - Storage methods
    private func newUserJoined(member: ScaledroneMember){
        currentUsers.append(member)
        NotificationCenter.default.post(name: .NewUserJoinedChat, object: nil)
    }
    
    private func userLeftChat(member: ScaledroneMember){
        var index = 0
        for currentMember in currentUsers{
            if currentMember.id == member.id{
                break
            } else {
                index+=1
            }
        }
        currentUsers.remove(at: index)
        NotificationCenter.default.post(name: .UserLeftChat, object: nil)
    }
    
    //MARK: - Public methods
    func getCurrentUsers() -> [User]{
        var usersList:[User] = []
        for currentUser in currentUsers{
            if let user = User(fromJSON: currentUser.clientData as Any){
                usersList.append(user)
            }
        }
        return usersList
    }
    
    func getAmountOfOnlineUsers() -> Int{
        return currentUsers.count
    }
    
}

// MARK: - Private
private extension ChatService {
    func getKey(message: String) -> String {
        let messageComponents = message.split(separator: "\n")
        return String(messageComponents[0])
    }
    
    func getMessageBody(message: String) -> String {
        let messageComponents = message.split(separator: "\n")
        return String(messageComponents[messageComponents.count - 1])
    }
    
    func decryptMessage(text: String) -> String {
        let key = getKey(message: text)
        let messageBody = getMessageBody(message: text)
        let cryptographer = Cryptographer()
        cryptographer.setKey(key: key)
        return cryptographer.decrypt(text: messageBody)
    }
}
