//
//  Message.swift
//  Intercom
//
//  Created by  Ronit D. on 11/20/20.
//

import MessageKit


struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}
