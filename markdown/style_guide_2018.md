// TODO(Shareef):
  Cover Comment Syle
  Includes Style
  Forward Declarations

# Norse Code's 2018 Style Guide :

## Indentation

### Tabs vs Spaces

- We use **SPACES** not tabs.
 - Preferably 2 spaces since that’s how Mead likes it but honestly doesn’t matter to me.
   Just be consistent and be reasonable, 4 should be the max.

### Namespaces

- Code within namespaces should be indented:

  - Right:
  
  ```cpp
      // my_class.hpp
    namespace engine
    {
      namespace detail
      {
        class InternalClass
        {
          protected:
            void internalImpl();
          ...
        };
      }
  
      class MyClass
      {
        public:
          MyClass() = default;
          ...
      };
    }

      // my_class.cpp
    namespace engine
    {
      namespace detail
      {
        void InternalClass::internalImpl()
        {
          ...
        }
      }
    }
  ```
  
  - Wrong:
  
  ```cpp
      // my_class.hpp
    namespace engine
    {
      namespace detail
      {
        class InternalClass
        {
          protected:
            void internalImpl();
          ...
        };
      }
  
      class MyClass
      {
        public:
          MyClass() = default;
          ...
      };
    }

      // my_class.cpp
    namespace engine
    {
    namespace detail
    {
    void InternalClass::internalImpl()
    {
      ...
    }
    }
    }
  ```

### Switch Statements

- Switch cases should be indented.
  - I prefer to also put indented braces since I find it easier to read that way.

  - EX:
  ```cpp
      // The braces are optional unless you declare a variable inside of a case.
    switch (condition)
    {
      case CONDITION_ONE:
        {
          ++i;
          break;
        }
      case CONDITION_ONE:
        {
          --i;
          break;
        }
      default:
        i += 5;
        break;
    }
  ```

## Spacing

- **Do not** place spaces around unary operators.
- **Do** place spaces around binary and ternary operators.
- Place spaces around the colon in a range-based for loop.
- Do not place spaces before comma and semicolon.
- Place spaces between control statements and their parentheses.
- Do not place spaces between a function and its parentheses, or between a parenthesis and its content.
- When initializing an object, place a space before the leading brace as well as between the braces and their content.

## Line Breaks
- Each statement should get its own line.
- An else statement should go on the same line as a preceding close brace if one is present, else it should line up with the if statement.
- An else if statement should be written as an if statement when the prior if concludes with a return statement.

## Floating Point Literals
- Unless required in order to force floating point math, do not append .0, .f and .0f to floating point literals.

## Braces
- Control clauses without a body should use empty braces:

## Null, True, False, 0
- In C++, the null pointer value should be written as nullptr. In C, it should be written as NULL.
- Tests for true/false, null/non-null, and zero/non-zero should all be done without equality comparisons.

## File Naming Conventions

- File names should be all lowercase with words separated by underscores:
  - Ex: “batch_renderer.hpp”
  
- File Extensions:
  - If you are writing C++ code use ".hpp" and ".cpp" file extensions
  - If you are writing C code use ".h" and ".c" file extensions
  - This is because for some Compilers you can make them interpret the different files extensions in different ways.
- • If you can put the code files in the actual directory in the SVN then add it to the project. This is so the project folder is not cluttered up with random ass files everywhere.

## Free Function Naming Conventions

## Class / Struct Naming Conventions

- Classes and Structs should use the CamelCase naming convention.
  - C++ Example
  ```cpp
      // Example C++ Class
      // The ‘CamelCase_t’ can be left off but will be there in my code.
    class CamelCase
    {
      ... fields and methods ...
    };
  ```
  
  - C Example
  ```c
      // Example C Struct
      // The ‘CStyleCamelCaseStruct_t’ can be left off but will be there in my code,
      // it's for easy C and C++ Interop.
    typedef struct CStyleCamelCaseStruct_t
    {
      ... fields and shit ...
    } CStyleCamelCaseStruct;
  ```

### Member Variable Naming Conventions (C++ Only)

#### Method Naming Conventions (C++ ONLY)

##### Overiding Methods

#### Functions that Operate on Struct(s) (C ONLY)

## Enum Naming Conventions

## Typedef (and Using)

- In C++ there is a new 'using' keyword.
  - For proper C++ style you should prefer to use _using_ rather than _typedef_ although there is no technical difference between the two. 
  - (Although) _using_ does provide some extra features if you are a template god.
  
  ```cpp
      // This is prefered.
    using MyFunctionPtr = void (*)(int someArg);
      // You can see how this is a bit messier with no advantage.
    typedef void (*MyFunctionPtr)(int someArg);
  ```

## Macros

- Macros should be declared at the top of the file and in all capitals:

  ```c
      // This macros gives me the max of two values.
    #define MAX(a, b) ((a) > (b)) ? (a) : (b)
  ```

- If you can ‘#undef’ ing the macro when you’re done with it is a good idea.

  ```c
      // This is so this macro doesn’t clutter the global ‘namespace’
    #undef MAX(a, b)
  ```

## Other Code Style Notes
- Avoid using global variables as much as possible, if you absolutely needs a global variable make sure to have is scopes as small as possible. Such as using the ‘static’ keyword in a ‘*.c’ file.
- I prefer having curly bois (‘{‘ and ‘}’) on a new line but won’t enforce it.

---

# Project Set Up
