(* This file was auto-generated based on "parser.messages". *)

(* Please note that the function [message] can raise [Not_found]. *)

let message s =
  match s with
  | 0 -> "expected a law heading, a law article, some text of the declaration of a master file\n"
  | 1 ->
      "expected an inclusion of a Catala file, since this file is a master file which can only \
       contain inclusions of other Catala files\n"
  | 7 ->
      "expected another inclusion of a Catala file, since this file is a master file which can \
       only contain inclusions of other Catala files\n"
  | 318 -> "expected some text, another heading or a law article\n"
  | 323 -> "expected a code block, a metadata block, more law text or a heading\n"
  | 329 -> "expected a code block, a metadata block, more law text or a heading\n"
  | 324 -> "expected a declaration or a scope use\n"
  | 22 -> "expected the name of the scope you want to use\n"
  | 24 -> "expected a scope use precondition or a colon\n"
  | 25 -> "expected an expression which will act as the condition\n"
  | 26 -> "expected the first component of the date literal\n"
  | 28 -> "expected a \"/\"\n"
  | 29 -> "expected the second component of the date literal\n"
  | 30 -> "expected a \"/\"\n"
  | 31 -> "expected the third component of the date literal\n"
  | 32 -> "expected a delimiter to finish the date literal\n"
  | 57 -> "expected an operator to compose the expression on the left with\n"
  | 63 -> "expected an enum constructor to test if the expression on the left\n"
  | 62 -> "expected an operator to compose the expression on the left with\n"
  | 118 -> "expected an expression on the right side of the sum or minus operator\n"
  | 146 -> "expected an expression on the right side of the logical operator\n"
  | 65 -> "expected an expression for the argument of this function call\n"
  | 106 -> "expected an expression on the right side of the comparison operator\n"
  | 127 -> "expected an expression on the right side of the multiplication or division operator\n"
  | 120 -> "expected an operator to compose the expression on the left\n"
  | 156 -> "expected an expression standing for the set you want to test for membership\n"
  | 58 -> "expected an identifier standing for a struct field or a subscope name\n"
  | 198 -> "expected a colon after the scope use precondition\n"
  | 60 -> "expected a constructor, to get the payload of this enum case\n"
  | 130 -> "expected the \"for\" keyword to spell the aggregation\n"
  | 131 -> "expected an identifier for the aggregation bound variable\n"
  | 132 -> "expected the \"in\" keyword\n"
  | 133 ->
      "expected an expression standing for the set over which to compute the aggregation operation\n"
  | 135 -> "expected the \"for\" keyword and the expression to compute the aggregate\n"
  | 136 -> "expected an expression to compute its aggregation over the set\n"
  | 140 -> "expected an expression to take the negation of\n"
  | 54 -> "expected an expression to take the opposite of\n"
  | 43 -> "expected an expression to match with\n"
  | 182 -> "expected a pattern matching case\n"
  | 183 -> "expected the name of the constructor for the enum case in the pattern matching\n"
  | 189 ->
      "expected a binding for the constructor payload, or a colon and the matching case expression\n"
  | 190 -> "expected an identifier for this enum case binding\n"
  | 186 -> "expected a colon and then the expression for this matching case\n"
  | 192 -> "expected a colon or a binding for the enum constructor payload\n"
  | 187 -> "expected an expression for this pattern matching case\n"
  | 184 ->
      "expected another match case or the rest of the expression since the previous match case is \
       complete\n"
  | 181 -> "expected the \"with patter\" keyword to complete the pattern matching expression\n"
  | 44 -> "expected an expression inside the parenthesis\n"
  | 179 -> "unmatched parenthesis that should have been closed by here\n"
  | 66 -> "expected a unit for this literal, or a valid operator to complete the expression \n"
  | 46 -> "expected an expression for the test of the conditional\n"
  | 175 -> "expected an expression the for the \"then\" branch of the conditiona\n"
  | 176 ->
      "expected the \"else\" branch of this conditional expression as the \"then\" branch is \
       complete\n"
  | 177 -> "expected an expression for the \"else\" branch of this conditional construction\n"
  | 174 -> "expected the \"then\" keyword as the conditional expression is complete\n"
  | 48 ->
      "expected the \"all\" keyword to mean the \"for all\" construction of the universal test\n"
  | 160 -> "expected an identifier for the bound variable of the universal test\n"
  | 161 -> "expected the \"in\" keyword for the rest of the universal test\n"
  | 162 -> "expected the expression designating the set on which to perform the universal test\n"
  | 163 -> "expected the \"we have\" keyword for this universal test\n"
  | 159 -> "expected an expression for the universal test\n"
  | 168 -> "expected an identifier that will designate the existential witness for the test\n"
  | 169 -> "expected the \"in\" keyword to continue this existential test\n"
  | 170 -> "expected an expression that designates the set subject to the existential test\n"
  | 171 -> "expected a keyword to form the \"such that\" expression for the existential test\n"
  | 172 -> "expected a keyword to complete the \"such that\" construction\n"
  | 166 -> "expected an expression for the existential test\n"
  | 75 ->
      "expected a payload for the enum case constructor, or the rest of the expression (with an \
       operator ?)\n"
  | 150 -> "expected an expression for the content of this enum case\n"
  | 151 ->
      "the expression for the content of the enum case is already well-formed, expected an \
       operator to form a bigger expression\n"
  | 53 -> "expected the keyword following cardinal to compute the number of elements in a set\n"
  | 199 -> "expected a scope use item: a rule, definition or assertion\n"
  | 200 -> "expected the name of the variable subject to the rule\n"
  | 219 ->
      "expected a condition or a consequence for this rule, or the rest of the variable qualified \
       name\n"
  | 214 -> "expected a condition or a consequence for this rule\n"
  | 205 -> "expected filled or not filled for a rule consequence\n"
  | 215 -> "expected the name of the parameter for this dependent variable \n"
  | 202 -> "expected the expression of the rule\n"
  | 208 -> "expected the filled keyword the this rule \n"
  | 220 -> "expected a struct field or a sub-scope context item after the dot\n"
  | 222 -> "expected the name of the variable you want to define\n"
  | 223 -> "expected the defined as keyword to introduce the definition of this variable\n"
  | 225 -> "expected an expression for the consequence of this definition under condition\n"
  | 224 ->
      "expected a expression for defining this function, introduced by the defined as keyword\n"
  | 226 -> "expected an expression for the definition\n"
  | 229 -> "expected an expression that shoud be asserted during execution\n"
  | 230 -> "expecting the name of the varying variable\n"
  | 232 -> "the variable varies with an expression that was expected here\n"
  | 233 -> "expected an indication about the variation sense of the variable, or a new scope item\n"
  | 231 -> "expected an indication about what this variable varies with\n"
  | 203 -> "expected an expression for this condition\n"
  | 211 -> "expected a consequence for this definition under condition\n"
  | 242 -> "expected an expression for this definition under condition\n"
  | 238 -> "expected the name of the variable that should be fixed\n"
  | 239 -> "expected the legislative text by which the value of the variable is fixed\n"
  | 240 -> "expected the legislative text by which the value of the variable is fixed\n"
  | 246 -> "expected a new scope use item \n"
  | 249 -> "expected the kind of the declaration (struct, scope or enum)\n"
  | 250 -> "expected the struct name\n"
  | 251 -> "expected a colon\n"
  | 252 -> "expected struct data or condition\n"
  | 253 -> "expected the name of this struct data \n"
  | 254 -> "expected the type of this struct data, introduced by the content keyword\n"
  | 255 -> "expected the type of this struct data\n"
  | 280 -> "expected the name of this struct condition\n"
  | 273 -> "expected a new struct data, or another declaration or scope use\n"
  | 274 -> "expected the type of the parameter of this struct data function\n"
  | 278 -> "expected a new struct data, or another declaration or scope use\n"
  | 267 -> "expected a new struct data, or another declaration or scope use\n"
  | 270 -> "expected a new struct data, or another declaration or scope use\n"
  | 283 -> "expected the name of the scope you are declaring\n"
  | 284 -> "expected a colon followed by the list of context items of this scope\n"
  | 285 -> "expected a context item introduced by \"context\"\n"
  | 286 -> "expected the name of this new context item\n"
  | 287 -> "expected the kind of this context item: is it a condition, a sub-scope or a data?\n"
  | 288 -> "expected the name of the subscope for this context item\n"
  | 295 -> "expected the next context item, or another declaration or scope use\n"
  | 290 -> "expected the type of this context item\n"
  | 291 -> "expected the next context item or a dependency declaration for this item\n"
  | 293 -> "expected the next context item or a dependency declaration for this item\n"
  | 298 -> "expected the name of your enum\n"
  | 299 -> "expected a colon\n"
  | 300 -> "expected an enum case\n"
  | 301 -> "expected the name of an enum case \n"
  | 302 -> "expected a payload for your enum case, or another case or declaration \n"
  | 303 -> "expected a content type\n"
  | 308 -> "expected another enum case, or a new declaration or scope use\n"
  | 18 -> "expected a declaration or a scope use\n"
  | 20 -> "expected a declaration or a scope use\n"
  | 314 ->
      "should not happen, please file an issue at https://github.com/CatalaLang/catala/issues\n"
  | _ -> raise Not_found
