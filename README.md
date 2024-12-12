This project implements a library for handling and manipulating "Pstrings," a custom string format where the first byte stores the string's length, and the remaining bytes store
the string content. The project was developed in both C and Assembly AT&T syntax.

Features:
The library supports the following operations:

Calculate Length (pstrlen): Returns the length of a Pstring.
Swap Case (swapCase): Converts all uppercase letters to lowercase and vice versa in the Pstring.
Substring Copy (pstrijcpy): Copies a substring from one Pstring to another within specific indices.
Concatenate Strings (pstrcat): Concatenates two Pstrings, provided the total length does not exceed 254.
Project Structure:
main.c: Implements the main function that interacts with the user, builds Pstrings, and calls the appropriate library functions.
pstrings.h: Header file defining the Pstring structure and function prototypes.
pstring.s: Assembly implementation of the library functions.
func_select.s: Assembly function that maps user input to the correct library function.
Makefile: Used to build the project.
