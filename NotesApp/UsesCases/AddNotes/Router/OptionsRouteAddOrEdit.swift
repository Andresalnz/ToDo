//
//  OptionsRouteAddOrEdit.swift
//  NotesApp
//
//  Created by Andres Aleu on 26/11/24.
//

import Foundation

enum OptionsRoute {
    case edit(ListNotes)
    case add
}

enum OptionsActionsAddEditOrDelete {
    case edit(ListNotes)
    case add
    case delete(ListNotes)
}
