[lh-cpp](lhCpp.md) provides the following features related to enums:
  * [generation of a scoped and iterable enumerated type](#Enum_snippet.md)
  * [for-snippet for the iterable enum](#Enum_iteration.md)
  * [automated generation of a switch-case statement from an enum](#switch-case_generation.md)


### Enum snippet ###

lh-cpp ships a [µtemplate](muTemplate.md) snippet that expands `enum` into an enum definition with the following properties:
  * C++ scoped (no `MYENUM_VAL1`, `MYENUM_VAL2`, ... but `MYENUM::VAL1`, `MYENUM::VAL2`, ...) (which can be taken advantage of in C++ template functions)
  * the number of elements is automatically provided (which can be used, for instance, into static assertions in order to check that an associated array of strings has a consistant dimension)
  * iterable with no need to explicitly cast an `int` into the enum type.

Let's say you answer "`MyEnum`" when requested with the enum name, the following will be inserted:
```
struct MyEnum {
    enum type { «values», MAX__ };
    static type next(type e_) {
	assert(e_ < MAX__);
	return type(e_+1);
    }
    static char const* to_string(type e_);
    static type to_enum(std::string const& s_);
};
inline
MyEnum::type& operator++(MyEnum::type& e_) {
    return e_ = MyEnum::next(e_);
}
inline
MyEnum::type operator++(MyEnum::type&e_, int) {
    const MyEnum::type tmp = e_;
    e_ = MyEnum::next(e_);
    return tmp;
}
```

### Enum iteration ###

In order to take advantage of the particular format of the [iterable enum](#Enum_snippet.md), a [µtemplate](muTemplate.md) snippet is provided to iterate over all enumerated values.

`for-enum` will expand into:
```
for (MyEnum::type «e» = MyEnum::type() ; «e» != MyEnum::MAX__ ; ++«e» ) {
    «»
}«»
```

### switch-case generation ###

Given an [iterable enum](#Enum_snippet.md) variable or type name, type this name and then hit `<c-x>se`. lh-cpp will fill [µtemplate](muTemplate.md) switch-case snippets with all possible values from the enum type. e.g. with:
```
struct MyEnum {
    enum type { V1, V2, V42, MAX__ };
...
MyEnum::type some_enum_var;
```
in INSERT-mode `some_enum_var^Xse` expands into:
```
switch (some_enum_var) 
{
    case MyEnum::V1:
        {
            «MyEnum::V1-code»;
            break;
        }
    case MyEnum::V2:
        {
            «MyEnum::V2-code»;
            break;
        }
    case MyEnum::V42:
        {
            «MyEnum::V42-code»;
            break;
        }
    default:
        {
            «default-code»;
            break;
        }
}«»
```
As of today this feature requires a ctags database containing all the tags related to the enum, and an [iterable enum](#Enum_snippet.md). (I plan to support [C++0x class-enums](http://en.wikipedia.org/wiki/C%2B%2B0x#Strongly_typed_enumerations) and to find eventually an alternative to ctags)