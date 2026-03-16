### Understanding the Makefile

The included `Makefile` is designed to automate the assembly and linking process. Instead of typing long terminal commands for every file, you can simply run:

* **`make run`**: Compiles, links and runs the main.s file.
* **`make run`**: Compiles, links with GDB (requires main) and runs the main.s file with external C functions.
* **`make SRC=filename.s`**: Assembles and links the specified file.
* **`make run SRC=filename.s`**: Compiles the file and immediately executes the binary.
* **`make debug`**: Starts TUI debuger in GDB with source code, registers, and stack at display.

Added for personal convenience. You can still compile and link it yourself.

---

### Current Files

These files represent my current study progression:

* **01_hello_world.s**: Basic program structure and system calls.
* **02_functions.s**: Implementing subroutines and the `jmp` instruction.
* **03_stack_preview.s**: Initial experiments with the stack pointer.
* **04_real_stack.s**: Practical use of `call` and `ret` for function creation.
* **05_loops.s**: Implementing control flow using jumps (`jmp`, `je`, `jne`, etc...).
* **06_conditionals.s**: Showcasing `cmp` to handle branching logic.
* **07_basic_str_len.s**: Manipulating pointers to calculate string length.
* **08_print_function.s**: Standardizing printing logic for reuse.
* **09_mul_div.s**: Showcasing arithmetic operations beyond addition/subtraction.
* **10_int_to_ascii.s**: Converting raw numerical data into printable characters, and to binary.
* **11_read.s**: Reads data from the terminal and prints them back.
* **12_simple_arrays.s**: Showcases how arrays work in assembly using simple examples.
* **13_tokenizer.s**: Full tokenizer app to clear unnecessary whitespaces and break strings into tokens.
* **14_compare_strings.s**: Checks if two strings are the same. Also has more comples version, which checks if n-characters of two strings are the same.
* **15_tiny_shell.s**: Tiny Shell with three commands: echo (prints string), exit (exits app), help (prints help manual). Also has support for unsupported commands.
* **16_objects.s**: Added objects to showcase how they work.
* **17_command_table.s**: Upgraded Tiny Shell with command tables.
* **18_stack.s**: Code showcasing how stack works.
* **19_basic_heap.s**: Basic code showcasing how heap works using Brk() code.
* **20_vtables_and_oop.s**: Example of how OOP languages are compiled to assembly and how Virtual Tables work.
* **21_random_number.s**: A random number generator with raw to decimal convertor and a range settings.
* **22_random_array.s**: An array of random numbers in range 1-100. Used as a template for further sorting techniques.
* **23_recursion.s**: Simple factorial function using recursion.
* **24_quicksort.s**: Quicksort algorithm using code from random_array as basis.
* **25_binary_search.s**: Binary search algorithm using code from quicksort as basis.
* **26_sha256.s**: Created a sha256 encoder. Also started using other system for writing functions that looks more readable.
* **27_floating_points.s**: Simple showcase of how floating point arithmetics work in assembly.
* **28_C_functions.s**: Showcase on how C functions can be called in assembly.


* **lab1.s**: Hello world example.
* **lab1.s**: Different loops.

---

### Status

**Note:** This repository is a **Work in Progress**. Topics and examples are being added as I work through my university syllabus. Also current files list might be not yet set to display all new files.
