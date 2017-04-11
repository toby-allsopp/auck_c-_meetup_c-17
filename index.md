---
title: C++17
subtitle: Auckland C++ Meetup
author: Toby Allsopp <toby@mi6.nz>
date: 12 April 2017
width: 100%
height: 100%
controls: 0
css:
 - index.css
---

# Community

## PacifiC++

> - A C++ conference in New Zealand!
> - Held in Christchurch 26th and 27th of October 2017
> - Keynotes from Jason Turner and Chandler Carruth
> - Taking submissions for talks
> - You should go!
> - <https://pacificplusplus.com/>

## Slack

- Like IRC
- Go to <http://cpplang.diegostamigni.com/> to get invite
- Lots of very knowledgeable people willing to answer questions

## Twitter

- Interesting people to follow:
    - <https://twitter.com/pacificplusplus>
    - <https://twitter.com/c_plus_plus>
    - <https://twitter.com/isocpp>
    - <https://twitter.com/meetingcpp>

## CppCast Podcast

- Hosted by Rob Irving and Jason Turner
- <http://cppcast.com/>
- Approximately weekly episodes

# A word from our sponsor

## JetBrains license raffle

* One 100% off voucher to give away

# C++17 Status

## Standardisation

![status](https://isocpp.org/files/img/wg21-timeline-2017-03.png)\ 

## C++17 Status

- Draft International Standard
- Sent for ballot to national bodies
- Expected to be published in 2017

## What's in it?

* Actually quite a lot
* Too much to go through in any detail

## What's in it for _me_?

> - Depends who you are
> - I'll try to hit the changes that will have a big impact

## What's _not_ in it?

> - Concepts
> - Ranges
> - Modules
> - 😢🎻

## Acknowledgements

* Presentation style and examples stolen from Tony Van Eerd <https://github.com/tvaneerd/cpp17_in_TTs>
* List of papers taken from <https://isocpp.org/files/papers/p0636r0.html> by Thomas Köppe

# Structured bindings

## Structured bindings

<table>
<tr><th>C++14</th><th>C++17</th></tr>
<tr>
<td>
~~~c++
for (auto&& entry : map) {
  auto&& key = entry.first;
  auto&& value = entry.second;
  cout << key << " = " << value;
}
~~~
</td>
<td>
~~~c++
for (auto&& [key, value] : map) {
  cout << key << " = " << value;
}
~~~
</td>
</tr>
<tr><th>C++17 human</th><th>C++17 compiler</th></tr>
<tr>
<td>
~~~c++
auto& [a, b] = foo();
~~~
</td>
<td>
~~~c++
auto& __tmp = foo();
auto& a = std::get<0>(__tmp); // not really
auto& b = std::get<1>(__tmp); // references
~~~
</td>
</tr>
</table>

## Works with

* `pair`
* `tuple`
* `array`
* arrays
* "plain" structs
* anything that allows `get<N>` like `tuple`

## Compiler support

* GCC 7
* Clang 4.0
* VS 2017 next toolchain update

# Init statement for if

## Init statement for `if`

<table>
<tr><th>C++14</th><th>C++17</th></tr>
<tr>
<td>
~~~c++
{
  auto o = get_object();
  if (o.valid()) {
    // do stuff
  }
}
~~~
</td>
<td>
~~~c++
if (auto o = get_object(); o.valid()) {
  // do stuff
}
~~~
</td>
</tr>
</table>

## Also for `switch`

~~~c++
switch (auto o = get_object(); o.state()) {
  case 1:
    // do stuff
    break;
  case 2:
    // do other stuff
    [[fallthrough]]; // LOOK HERE!
  case 3:
    // do more stuff
    break;
}
~~~

## Compiler support

* GCC 7
* Clang 3.9
* VS 2017 not yet

## Synergy

<table>
<tr><th>C++14</th><th>C++17</th></tr>
<tr>
<td>
~~~c++
std::set<int> s;
int x = 1;
{
  auto i = s.insert(x);
  if (i.second) {
    existing_item(*i.first);
  } else {
    new_item(*i.first);
  }
}
~~~
</td>
<td>
~~~c++
std::set<int> s;
int x = 1;
if (auto [iterator, inserted] = s.insert(x);
        inserted) {
    existing_item(*iterator);
} else {
  new_item(*iterator);
}
~~~
</td>
</tr>
</table>

# Nested namespaces

## Nested namespaces

<table>
<tr><th>C++14</th><th>C++17</th></tr>
<tr>
<td>
~~~c++
namespace foo {
  namespace bar {
    namespace baz {
    }
  }
}
~~~
</td>
<td>
~~~c++
namespace foo:bar::baz {
}
~~~
</td>
</tr>
</table>

## Compiler support

* GCC 6
* Clang 3.6
* VS 2015.3

# Optional

## Optional

<table>
<tr><th>C++14</th><th>C++17</th></tr>
<tr>
<td>
~~~c++
bool parse(const string& s, int& output);

int output;
if (parse(s, output)) {
  process(output);
}
~~~
</td>
<td>
~~~c++
optional<int> parse(const string& s);

if (auto result = parse(s)) {
  process(*result);
}
~~~
</td>
</tr>
</table>

## Compiler support

* libstdc++ 7
* libc++ 4.0
* VS 2017

# Variant

## Variant

<table>
<tr><th>C++14</th><th>C++17</th></tr>
<tr>
<td>
~~~c++
struct open { int time_open; };
struct closed { string closer; };
struct state {
  enum { OPEN, CLOSED } which;
  open o; // only valid if OPEN
  closed c; // only valid if CLOSED
}

void handle_state(open);
void handle_state(closed);

state s;
switch (s.which) {
  case state::OPEN:
    handle_state(s.o);
    break;
  case state::CLOSED:
    handle_state(s.c);
    break;
}
~~~
</td>
<td>
~~~c++
struct open { int time_open; };
struct closed { string closer; };
using state = variant<open, closed>;

void handle_state(open);
void handle_state(closed);

state s;

visit(
  [](const auto& s) {
    handle_state(s);
  },
  s);
~~~
</td>
</tr>
</table>

## Compiler support

* libstdc++ 7
* libc++ 4.0
* VS 2017

# Any

## Any

<table>
<tr><th>C++14</th><th>C++17</th></tr>
<tr>
<td>
~~~c++
void *anything = nullptr;
int i = 7;
std::string s = "Hello";
anything = &i;
if (anything) {
  int j = *reinterpret_cast<int*>(anything);
  // UB if you got it wrong
}
anything = &s;
~~~
</td>
<td>
~~~c++
std::any anything;
int i = 7;
std::string s = "Hello";
anything = i;
if (anything.has_value()) {
  int j = std::any_cast<int>(anything);
  // throws if you got it wrong
}
anything = s; // copies the string
~~~
</td>
</tr>
</table>

## Compiler support

* libstdc++ 7
* libc++ 4.0
* VS 2017

# Filesystem

## Filesystem

* Currently a Technical Specification
* Very similar to `boost::filesystem`
* GCC - use `std::experimental`
* Clang - use `std::experimental`
* Visual Studio - use `std::experimental`

# Class template argument deduction

## Deduction

* Like for function templates
* Class template arguments are deduced from the arguments passed to the constructor

<table>
<tr><th>C++14</th><th>C++17</th></tr>
<tr>
<td>
~~~c++
auto p = std::pair<int, double>{1, 1.2};
auto p = std::make_pair(1, 1.2);
~~~
</td>
<td>
~~~c++
auto p = std::pair{1, 1.2};
~~~
</td>
</tr>
</table>

## Deduction guides

* For every constructor that takes arguments matching the class template parameters, there is an implicit deduction guide
* You can write explicit deduction guides

~~~c++
template <typename T>
struct s {
  T x;
};

s(int) -> s<double>;

auto a = s{7}; // decltype(a) is s<double>
~~~

## Compiler support

* GCC 7
* Clang 5
* VS not yet

# `if constexpr`

## `if constexpr`


<table>
<tr><th>C++14</th><th>C++17</th></tr>
<tr>
<td>
~~~c++
struct s {
  int i;
  double d;
};

template<int N>
std::conditional_t<N==0, const int&, const double&>
get(const s&);

template<>
const int& get<0>(const s& s) {return s.i;}

template<>
const double& get<1>(const s& s) {return s.d;}
~~~
</td>
<td>
~~~c++
struct s {
  int i;
  double d;
};

template<int N>
auto& get(const s& s) {
  if constexpr (N == 0) {
    return s.i;
  }
  else if constexpr (N == 1) {
    return s.d;
  }
}
~~~
</td>
</tr>
</table>

# The future

## Concepts

* Constraints on template arguments
* Currently a Technical Specification
* Has been cooking since before C++11
* The committee can't agree on some of the details
* Hopefully will be merged into C++20
* Available in GCC

## Concepts example

<table>
<tr><th>C++14</th><th>Concepts TS</th></tr>
<tr>
<td>
~~~c++
template <typename T>
auto binarySearch(T first, T second)
{
   //...
}
~~~
</td>
<td>
~~~c++
template <RandomAccessIterator T>
auto binarySearch(T first, T second)
{
   //...
}
~~~
</td>
</tr>
<tr><th>C++14 compiler</th><th>Concepts compiler</th></tr>
<tr>
<td>
~~~
error: syntax error '[' unexpected
error: gibberish
error: more compiler gibberish
error: for pages and pages
...
~~~
</td>
<td>
~~~
error: MyIter does not model RandomAccessIterator
~~~
</td>
</tr>
</table>

## Modules

* Replacement for `#include`
* Promises vastly improved compilation times
* Draft TS
* Available in Visual Studio and Clang (with slight differences)
* Will probably go into C++20 (if those differences can be resolved)

## Ranges

* Defines Concepts for the standard library (`Copyable`, `Iterator`, etc.)
* Adds versions of algorithms that take "ranges" instead of pairs of iterators
* A range is basically just an object with `begin()` and `end()` that return iterators
* Allows for much greater composability of algorithms
* Draft TS
* Available in cmcstl2 if you have Concepts (i.e. GCC)
* Available in range-v3 along with some really nice stuff on top

## Coroutines

* Allows functions to be suspended and resumed
* Really useful for async and lazy algorithms
* Draft TS
* Available in Visual Studio and a special branch of Clang

# Questions

# Thank you

# References

##

* <https://github.com/tvaneerd/cpp17_in_TTs/blob/master/ALL_IN_ONE.md>
* <https://isocpp.org/files/papers/p0636r0.html>
* <http://en.cppreference.com/w/cpp/compiler_support>
* <https://gcc.gnu.org/onlinedocs/libstdc++/manual/status.html#status.iso.201z>
* <http://libcxx.llvm.org/cxx1z_status.html>
* <https://docs.microsoft.com/en-us/cpp/visual-cpp-language-conformance>

# Significant changes I haven't mentioned

## Removals

- Remove trigraphs
- Remove `register`
- Remove `operator++` for `bool`
- Remove non-empty exception specifications
- Remove `auto_ptr` and other library features deprecated since C++11
- Remove allocator support from `function`

## Deprecations

- Deprecate some C library headers
- Deprecate `allocator<void>`
- Deprecate `std::iterator`
- Deprecate `<codecvt>`
- Deprecate `memory_order_consume` temporarily
- Deprecate `shared_ptr::unique`
- Deprecate `result_of`

## Language changes

- `noexcept` is part of a function's type
- Guaranteed copy elision
- Dynamic allocation of over-aligned types
- Stricter order of expression evaluation
- UTF-8 character literals
- Hexadecimal floating point literals
- Different types for `begin` and `end` in range-based `for`

## Language changes part 2

- Constexpr lambdas
- Lambda capture of `*this`
- Inline variables
- `__has_include`
- `[[fallthrough]]`, `[[nodiscard]]`, `[[maybe_unused]]`
- `std::byte`

## Language changes part 3

- Single-argument `static_assert`
- template<auto>
- fold expressions
- Template template parameters can use `typename`
- Pack expansion in `using`

## Library changes

- parallel algorithms
- string_view
- mathematical special functions
- `clamp`, `gcd`, `lcm`, `hypot`
- `shared_mutex`
- `scoped_lock`
- `shared_ptr` improvements

## Library changes part 2

- Hardware interference sizes
- `apply`, `make_from_tuple`
- `not_fn`
- Polymorhpic allocator
- Substring search functions
- Splicing for node-based containers
- Non-const `string::data()`
- `to_chars`, `from_chars`

## Library changes part 3

- `invoke` and associated traits
- `void_t`
- `bool_constant`
- `conjunction`, `disjunction`, `negation`
- `is_swappable` etc.
- `is_aggregate`
- `has_unique_object_representations`
- `as_const`
- Traits variable templates

