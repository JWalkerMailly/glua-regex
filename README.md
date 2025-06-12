
# Regex

Regular expressions are patterns used to match character combinations in strings. These patterns are used with the Exec(), Test(), Match(), Replace(), Search(), and Split() methods. This module creates an instance of DHTML to process regular expressions using JavaScript and passes the result to a lua callback.

> [!NOTE]
> This module can only be used clientside due to its dependency on DHTML.

> [!CAUTION]
> This is a very hacky implementation. **Do not** nest regex functions into each other, this will cause Awesomium to panic. If you need to chain regex operations, use a concurrency design pattern approach.

## Methods

<code>regex.Test(<i>str, exp, callback, flags</i>)</code>

#### Example

```lua
regex.Test(
	"hello world",
	"hel+",
	function(result)
		print(result)
	end
)
```

```
> true
```

---

<code>regex.Exec(<i>str, exp, callback, flags</i>)</code>

#### Example

```lua
regex.Exec(
	"hello world",
	"hel+",
	function (result)
		PrintTable(result)
	end
)
```

```
> [1]	=	hell
```

---

<code>regex.Search(<i>str, exp, callback, flags</i>)</code>

#### Example

```lua
regex.Search(
	"hello world",
	"world",
	function (result)
		print(result)
	end
)
```

```
> 6
```

---

<code>regex.Replace(<i>str, exp, replace, callback, flags</i>)</code>

#### Example

```lua
regex.Replace(
	"I love JavaScript",
	"JavaScript",
	"lua",
	function (result)
		print(result)
	end
)
```

```
> "I love lua"
```

---

<code>regex.Match(<i>str, exp, callback, flags</i>)</code>

#### Example

```lua
regex.Match(
	"The quick brown fox jumps over the lazy dog. It barked.",
	"[A-Z]",
	function (result)
		PrintTable(result)
	end
)
```

```
> [1]	=	T
> [2]	=	I
```

---

<code>regex.Split(<i>str, exp, callback, flags</i>)</code>

#### Example

```lua
regex.Split(
	"The quick brown fox jumps over the lazy dog.",
	" ",
	function (result)
		PrintTable(result)
	end
)
```

```
> [1]	=	The
> [2]	=	quick
> [3]	=	brown
> [4]	=	fox
> [5]	=	jumps
> [6]	=	over
> [7]	=	the
> [8]	=	lazy
> [9]	=	dog.
```