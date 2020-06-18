//
//  main.swift
//  HW03_Swift
//
//  Created by Omid on 6/15/20.
//  Copyright © 2020 MobileProgramming. All rights reserved.
//

import Foundation

class TrieNode<T: Hashable> {
    
    var value: T?     // value of that node
    weak var parent: TrieNode?     // parent of the node
    var children: [T: TrieNode] = [:]     // children of the node
    var isTerminating = false     // if this node is end of a word?
    
    init(value: T? = nil, parent: TrieNode? = nil) {
        
        self.value = value
        self.parent = parent
        
    }
    
    func add(child: T) {
        
        guard children[child] == nil else { return }
        
        children[child] = TrieNode(value: child, parent: self)
        
    }
    
}

class Trie {
    
    fileprivate let root: TrieNode<Character>
    var results : [String: Int] = [:]
    
    init() {
        
        root = TrieNode<Character>()
        
    }
    
}

extension Trie {
    
    // insert new word to trie
    func insert(word: String) {
        
        guard !word.isEmpty else { return }
        
        var currentNode = root
        let characters = Array(word.characters)
        var currentIndex = 0
        
        while currentIndex < characters.count {
            
            let character = characters[currentIndex]
            
            // if we have same letters go through them else add new character to the trie
            if let child = currentNode.children[character] {
                currentNode = child
            } else {
                currentNode.add(child: character)
                currentNode = currentNode.children[character]!
            }
            
            currentIndex += 1
            
            // if we are at the last cell, update isTerminating of the node
            if currentIndex == characters.count {
                currentNode.isTerminating = true
            }
            
        }
        
    }
    
    // this function search to find th word
    func searchWord(node : TrieNode<Character>, table : [[String]], i : Int,
                    j : Int, visited : inout [[Bool]], str : String) {
        
        let rows = table.count
        let columns = table[0].count
        
        // if the (first, second) element of table is available and not visited
        func isOK(first : Int, second : Int) -> Bool {
            if((first>=0)&&(first<rows)&&(second>=0)&&(second<columns)) {
                return !visited[first][second];
            } else {
                return false;
            }
        }
        
        // if we arravied to the end of a word, update the results
        if(node.isTerminating) {
            if(results[str] == nil) {
                results.updateValue(1 , forKey : str);
            } else {
                results.updateValue(results[str]! + 1 , forKey : str);
            }
            
        }
        
        if(isOK(first : i, second : j)) {
            
            //visit this node and go through it's neighbors
            visited[i][j] = true;
            
            for child in node.children {
                
                if (isOK(first : i+1, second : j+1)) {
                    if (child.key == Character(table[i+1][j+1])) {
                        searchWord(node : child.value, table : table, i : i+1, j : j+1, visited : &visited, str : str+String(child.key))
                    }
                }
                
                if (isOK(first : i, second : j+1)) {
                    if (child.key == Character(table[i][j+1])) {
                        searchWord(node : child.value, table : table, i : i, j : j+1, visited : &visited, str : str+String(child.key))
                    }
                }
                
                if (isOK(first : i-1, second : j+1)) {
                    if (child.key == Character(table[i-1][j+1])) {
                        searchWord(node : child.value, table : table, i : i-1, j : j+1, visited : &visited, str : str+String(child.key))
                    }
                }
                
                if (isOK(first : i+1, second : j)) {
                    if (child.key == Character(table[i+1][j])) {
                        searchWord(node : child.value, table : table, i : i+1, j : j, visited : &visited, str : str+String(child.key))
                    }
                }
                
                if (isOK(first : i-1, second : j)) {
                    if (child.key == Character(table[i-1][j])) {
                        searchWord(node : child.value, table : table, i : i-1, j : j, visited : &visited, str : str+String(child.key))
                    }
                }
                
                if (isOK(first : i+1, second : j-1)) {
                    if (child.key == Character(table[i+1][j-1])) {
                        searchWord(node : child.value, table : table, i : i+1, j : j-1, visited : &visited, str : str+String(child.key))
                    }
                }
                
                if (isOK(first : i, second : j-1)) {
                    if (child.key == Character(table[i][j-1])) {
                        searchWord(node : child.value, table : table, i : i, j : j-1, visited : &visited, str : str+String(child.key))
                    }
                }
                
                if (isOK(first : i-1, second : j-1)) {
                    if (child.key == Character(table[i-1][j-1])) {
                        searchWord(node : child.value, table : table, i : i-1, j : j-1, visited : &visited, str : str+String(child.key))
                    }
                }
            }
            
            visited[i][j] = false;
        }
    }
    
    // find words of trie in table
    func findwords(table: [[String]]) {
        let rows = table.count
        let columns = table[0].count
        
        //make visited array for each table element
        var visited = Array(repeating: Array(repeating: false, count: columns), count: rows)
        
        //we start searching from root of the trie
        let currentNode = root
        var str = "";
        
        // we search all elements of the table and start searching the word if that letter is one of our root's children
        for i in 0..<rows {
            for j in 0..<columns {
                if let child = currentNode.children[Character(table[i][j])] {
                    str = str + table[i][j]
                    searchWord(node : child, table : table, i : i, j : j, visited : &visited, str : str)
                }
                str = "";
            }
        }
        
        // print the answers
        for (word, number) in results {
            print("There is '\(number)' of '\(word)' in the table")
        }
        
    }
    
}

// this is our starting method
func main() {
    
    // get list of words from user
    let words = readLine()
    guard !words!.isEmpty else { return }
    let wordsArr = words!.characters.split{$0 == " "}.map(String.init)
    
    // bulid our trie
    let trie = Trie()
    for word in wordsArr {
        trie.insert(word : word)
    }
    
    //get the table dimantions
    let numbers = readLine()
    guard !numbers!.isEmpty else { return }
    let numbersArr = numbers!.characters.split{$0 == " "}.map(String.init)
    let m = Int(numbersArr[0]) ?? 0
    let n = Int(numbersArr[1]) ?? 0
    
    var table = Array(repeating: Array(repeating: "", count: n), count: m)
    
    //get table data
    for i in 0..<m {
        
        let letters = readLine()
        guard !letters!.isEmpty else { return }
        let lettersArr = letters!.characters.split{$0 == " "}.map(String.init)
        guard (lettersArr.count == n) else { return }
        
        for j in 0..<n {
            table[i][j] = lettersArr[j];
        }
        
    }
    
    //find words in table and print them
    trie.findwords(table : table)
    print("PROGRAM FINISHED")
    
}

main();
