# https://youtu.be/xPujkWc88DM

1. **Composition over Inheritance**: Favor combining smaller, independent behaviors over building deep, rigid class hierarchies. This leads to more flexible and maintainable code.
2. **YAGNI (You Aren't Going to Need It)**: Avoid building complex infrastructure or features for a future you don't yet need. Solve today's problem and add complexity only when necessary.
3. **The Principle of Least Privilege**: Restrict access to data and functionality within your code to only what is absolutely necessary, which helps reduce bugs and headaches.
4. **Making Illegal States Unrepresentable**: Design your data and type system so that invalid states (e.g., a variable being both active and deleted) cannot exist, making defensive checks redundant.
5. **Code for Humans First**: Write code that is easy for other human developers (and your future self) to read and understand, using clear variable names and structure.
6. **Embracing Immutability**: Use immutable data structures where it matters to ensure data doesn't change unexpectedly, which simplifies debugging.
7. **Thinking in Pipelines**: Treat complex logic as a series of small, testable data transformations, where the output of one step becomes the input of the next.
8. **Understanding the Cost of Abstraction**: Evaluate whether an abstraction (like a framework) is truly gaining clarity or if it's just hiding complexity, which can lead to difficult debugging later.
9. **Accepting that Refactoring is Not Optional**: Treat refactoring as a necessary maintenance task to keep the codebase healthy, not an optional step for when you have extra time.
10. **Your Code Will Change**: Stop trying to perfectly predict the future. Build code that is easy to modify and adapt tomorrow, as requirements are guaranteed to change.
