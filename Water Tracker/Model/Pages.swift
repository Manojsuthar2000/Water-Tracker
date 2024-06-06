import Foundation

struct Page {
    let title: String
    let detail: String
}

struct Pages {
    let pages: [Page] = [
        Page(title: "How much do you weight?",
             detail: "The daily water intake for people of different weight varies greatly"),
        Page(title: "When do you usually wake up?",
             detail: "Getting hydrated right after waking up will give you energy in the morning!"),
        Page(title: "When do you usually end a day?",
             detail: "Drinking water 1 hour before sleep will keep you hydrated during your sweet dream")]
}

