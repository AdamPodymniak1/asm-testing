### Understanding the Makefile

The included `Makefile` is designed to automate the assembly and linking process. Instead of typing long terminal commands for every file, you can simply run:

* **`make run`**: Compiles, links and runs the main.s file.
* **`make SRC=filename.s`**: Assembles and links the specified file.
* **`make run SRC=filename.s`**: Compiles the file and immediately executes the binary.

Added for personal convenience. You can still compile and link it yourself.

---

### Current Files

These files represent my current study progression:

* **hello_world.s**: Basic program structure and system calls.
* **functions.s**: Implementing subroutines and the `jmp` instruction.
* **stack_preview.s**: Initial experiments with the stack pointer.
* **real_stack.s**: Practical use of `call` and `ret` for function creation.
* **loops.s**: Implementing control flow using jumps (`jmp`, `je`, `jne`, etc...).
* **conditionals.s**: Showcasing `cmp` to handle branching logic.
* **basic_str_len.s**: Manipulating pointers to calculate string length.
* **print_function.s**: Standardizing printing logic for reuse.
* **mul_div.s**: Showcasing arithmetic operations beyond addition/subtraction.
* **int_to_ascii.s**: Converting raw numerical data into printable characters, and to binary.
* **read.s**: Reads data from the terminal and prints them back.
* **simple_arrays.s**: Showcases how arrays work in assembly using simple examples.
* **tokenizer.s**: Full tokenizer app to clear unnecessary whitespaces and break strings into tokens.
* **compare_strings.s**: Checks if two strings are the same. Also has more comples version, which checks if n-characters of two strings are the same.

---

### Status

**Note:** This repository is a **Work in Progress**. Topics and examples are being added as I work through my university syllabus. Also current files list might be not yet set to display all new files.
