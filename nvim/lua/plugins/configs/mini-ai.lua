local ai = require("mini.ai")
local opts = {
	n_lines = 500,
	custom_textobjects = {
		o = ai.gen_spec.treesitter({
			a = { "@block.outer", "@conditional.outer", "@loop.outer" },
			i = { "@block.inner", "@conditional.inner", "@loop.inner" },
		}, {}),
		f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
		c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
	},
}
ai.setup(opts)

-- This table describes all builtin textobjects along with what they
-- represent. Explanation:
-- - `Key` represents the textobject identifier: single character which should
--   be typed after `a`/`i`.
-- - `Name` is a description of textobject.
-- - `Example line` contains a string for which examples are constructed. The
--   `*` denotes the cursor position.
-- - `a`/`i` describe inclusive region representing `a` and `i` textobjects.
--   Use numbers in separators for easier navigation.
-- - `2a`/`2i` describe either `2a`/`2i` (support for |v:count|) textobjects
--   or `a`/`i` textobject followed by another `a`/`i` textobject (consecutive
--   application leads to incremental selection).
--
-- Example: typing `va)` with cursor on `*` leads to selection from column 2
-- to column 12. Another typing `a)` changes selection to [1; 13]. Also, besides
-- visual selection, any |operator| can be used or `g[`/`g]` motions to move
-- to left/right edge of `a` textobject.
-- >
--  |Key|     Name      |   Example line   |   a    |   i    |   2a   |   2i   |
--  |---|---------------|-1234567890123456-|--------|--------|--------|--------|
--  | ( |  Balanced ()  | (( *a (bb) ))    |        |        |        |        |
--  | [ |  Balanced []  | [[ *a [bb] ]]    | [2;12] | [4;10] | [1;13] | [2;12] |
--  | { |  Balanced {}  | {{ *a {bb} }}    |        |        |        |        |
--  | < |  Balanced <>  | << *a <bb> >>    |        |        |        |        |
--  |---|---------------|-1234567890123456-|--------|--------|--------|--------|
--  | ) |  Balanced ()  | (( *a (bb) ))    |        |        |        |        |
--  | ] |  Balanced []  | [[ *a [bb] ]]    |        |        |        |        |
--  | } |  Balanced {}  | {{ *a {bb} }}    | [2;12] | [3;11] | [1;13] | [2;12] |
--  | > |  Balanced <>  | << *a <bb> >>    |        |        |        |        |
--  | b |  Alias for    | [( *a {bb} )]    |        |        |        |        |
--  |   |  ), ], or }   |                  |        |        |        |        |
--  |---|---------------|-1234567890123456-|--------|--------|--------|--------|
--  | " |  Balanced "   | "*a" " bb "      |        |        |        |        |
--  | ' |  Balanced '   | '*a' ' bb '      |        |        |        |        |
--  | ` |  Balanced `   | `*a` ` bb `      | [1;4]  | [2;3]  | [6;11] | [7;10] |
--  | q |  Alias for    | '*a' " bb "      |        |        |        |        |
--  |   |  ", ', or `   |                  |        |        |        |        |
--  |---|---------------|-1234567890123456-|--------|--------|--------|--------|
--  | ? |  User prompt  | e*e o e o o      | [3;5]  | [4;4]  | [7;9]  | [8;8]  |
--  |   |(typed e and o)|                  |        |        |        |        |
--  |---|---------------|-1234567890123456-|--------|--------|--------|--------|
--  | t |      Tag      | <x><y>*a</y></x> | [4;12] | [7;8]  | [1;16] | [4;12] |
--  |---|---------------|-1234567890123456-|--------|--------|--------|--------|
--  | f | Function call | f(a, g(*b, c) )  | [6;13] | [8;12] | [1;15] | [3;14] |
--  |---|---------------|-1234567890123456-|--------|--------|--------|--------|
--  | a |   Argument    | f(*a, g(b, c) )  | [3;5]  | [3;4]  | [5;14] | [7;13] |
--  |---|---------------|-1234567890123456-|--------|--------|--------|--------|
--  |   |    Default    |                  |        |        |        |        |
--  |   |   (digits,    | aa_*b__cc___     | [4;7]  | [4;5]  | [8;12] | [8;9]  |
--  |   | punctuation,  | (example for _)  |        |        |        |        |
--  |   | or whitespace)|                  |        |        |        |        |
--  |---|---------------|-1234567890123456-|--------|--------|--------|--------|
-- <
-- Notes:
-- - All examples assume default `config.search_method`.
-- - Open brackets differ from close brackets by how they treat inner edge
--   whitespace for `i` textobject: open ignores it, close - includes.
-- - Default textobject is activated for identifiers from digits (0, ..., 9),
--   punctuation (like `_`, `*`, `,`, etc.), whitespace (space, tab, etc.).
--   They are designed to be treated as separators, so include only right edge
--   in `a` textobject. To include both edges, use custom textobjects
--   (see |MiniAi-textobject-specification| and |MiniAi.config|).
