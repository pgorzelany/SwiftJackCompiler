import Lexer

let lexer = Lexer(source: "hello     ")
let results = try? lexer.getAllTokens()
print(results)
