   #David Goldstein 331010835
    .section .rodata
print_invalid:
    .string "invalid input!\n"
 # String printed when input is invalid

len_over:
    .string "cannot concatenate strings!\n"
 # String printed when concatenation is not possible

    .section .text
    .globl pstrlen
    .globl swapCase
    .globl pstrijcpy
    .globl pstrcat

pstrlen:
    pushq %rbp
 # Save old base pointer
    movq %rsp, %rbp
 # Set new base pointer
    movb (%rdi), %al
 # Load length byte of Pstring into AL
    movq %rbp, %rsp
    # Restore stack pointer
       popq %rbp
    # Restore base pointer
       ret
 # Return to caller

swapCase:
    pushq %rbp
 # Save old base pointer
    movq %rsp, %rbp
 # Set new base pointer
    pushq %rdx
 # Save RDX on the stack
    movq %rdi, %rax
 # RAX = pointer to the Pstring
    movb (%rdi), %cl
 # CL = length of the Pstring
    lea 1(%rax), %rsi
 # RSI = address of the first character

loop:
    testb %cl, %cl
 # Check if length is zero
    je endSwap
 # If zero, jump to finishedSwap
    movb (%rsi), %dl
 # DL = current character
    cmpb $'A', %dl
 # Compare character with 'A'
    jl swapletter
 # If character < 'A', jump to IsLower
    cmpb $'Z', %dl
 # Compare character with 'Z'
    jg swapletter
 # If character > 'Z', jump to IsLower
    orb $0x20, %dl
 # Convert uppercase to lowercase
    movb %dl, (%rsi)
 # Store modified character
    jmp nextLetter
 # Go to NextChar

swapletter:
    cmpb $'a', %dl
 # Compare character with 'a'
    jl nextLetter
 # If character < 'a', go to NextChar
    cmpb $'z', %dl
 # Compare character with 'z'
    jg nextLetter
 # If character > 'z', go to NextChar
    andb $0xDF, %dl
 # Convert lowercase to uppercase
    movb %dl, (%rsi)
 # Store modified character

nextLetter:
    inc %rsi
 # Move to next character
    dec %cl
 # Decrement length counter
    jmp loop
 # Repeat loop

endSwap:
    popq %rdx
 # Restore RDX
    movq %rbp, %rsp
 # Restore stack pointer
    popq %rbp
 # Restore base pointer
    ret
 # Return to caller

pstrijcpy:
    pushq %rbp
 # Save old base pointer
    movq %rsp, %rbp
 # Set new base pointer
    pushq %rbx
 # Save RBX
    pushq %r12
 # Save R12
    pushq %r13
 # Save R13
    pushq %r14
 # Save R14
    pushq %r15
 # Save R15
    subq $16, %rsp
 # Allocate 16 bytes for local storage
    movq %rdi, %rbx
 # RBX = dst pointer
    movq %rsi, %r12
 # R12 = src pointer
    movl %edx, %r13d
 # R13d = i
    movl %ecx, %r14d
 # R14d = j
    movq %rbx, %rax
 # RAX = dst pointer
    movzbl (%r12), %r8d
 # R8d = src length
    movzbl (%rbx), %r9d
 # R9d = dst length
    cmpb %r14b, %r13b
 # Compare j and i
    ja invalid
 # If i > j, jump to invalid
    cmpb %r8b, %r13b
 # Check if i >= src length
    jae invalid
 # If out of range, invalid
    cmpb %r8b, %r14b
 # Check if j >= src length
    jae invalid
 # If out of range, invalid
    cmpb %r9b, %r13b
 # Check if i >= dst length
    jae invalid
 # If out of range, invalid
    cmpb %r9b, %r14b
 # Check if j >= dst length
    jae invalid
 # If out of range, invalid
    movl %r13d, %r10d
 # R10d = i
    movl %r14d, %r11d
 # R11d = j
    subl %r10d, %r11d
 # j - i
    incl %r11d
 # (j - i) + 1
    lea 1(%r12, %r10), %r8
 # R8 = src + i + 1
    lea 1(%rbx, %r10), %r9
 # R9 = dst + i + 1

copy_loop_pstrijcpy:
    testl %r11d, %r11d
 # Check remaining chars
    jz done_copy_pstrijcpy
 # If zero, done copying
    movb (%r8), %r15b
 # Load byte from src
    movb %r15b, (%r9)
 # Store byte into dst
    incq %r8
 # Increment src pointer
    incq %r9
 # Increment dst pointer
    decl %r11d
 # Decrement count
    jmp copy_loop_pstrijcpy
 # Repeat loop

done_copy_pstrijcpy:
    addq $16, %rsp
 # Restore stack space
    jmp finish_pstrijcpy
 # Jump to finish

invalid:
    pushq %rax
 # Save RAX
    pushq %rdi
 # Save RDI
    lea print_invalid(%rip), %rdi
 # RDI = address of "invalid input!\n"
    xor %eax, %eax
 # Clear EAX
    call printf
 # Print invalid message
    popq %rdi
 # Restore RDI
    popq %rax
 # Restore RAX
    addq $16, %rsp
 # Restore stack space
    jmp finish_pstrijcpy
 # Jump to finish

finish_pstrijcpy:
    popq %r15
 # Restore R15
    popq %r14
 # Restore R14
    popq %r13
 # Restore R13
    popq %r12
 # Restore R12
    popq %rbx
 # Restore RBX
    movq %rbp, %rsp
     # Restore stack pointer
      popq %rbp
     # Restore base pointer
    ret
 # Return to caller

pstrcat:
    pushq %rbp
 # Save old base pointer
    movq %rsp, %rbp
 # Set new base pointer
    subq $8, %rsp
 # Allocate 8 bytes for alignment
    movq %rdi, %rax
 # RAX = dst pointer
    movzbl (%rdi), %edx
 # EDX = dst length
    movzbl (%rsi), %ecx
 # ECX = src length
    movl %edx, %r8d
 # R8d = dst length
    addl %ecx, %r8d
 # R8d = dst length + src length
    cmpl $254, %r8d
 # Compare with 254 max length
    jg cannot_concatenate
 # If greater than 254, jump to cannot_concatenate
    xorl %r9d, %r9d
 # R9d = 0 (counter)

copyloop_pstrcat:
    cmpl %ecx, %r9d
 # Compare counter with src length
    jge donecopy_pstrcat
 # If done, jump to donecopy_pstrcat
    movzbl 1(%rsi,%r9), %r10d
 # Load byte from src at src[1+i]
    movb %r10b, 1(%rdi,%rdx)
 # Store byte into dst
    incq %r9
 # Increment counter
    incq %rdx
 # Move dst pointer
    jmp copyloop_pstrcat
 # Repeat loop

donecopy_pstrcat:
    movb %r8b, (%rdi)
 # Update dst length byte
    movq %rbp, %rsp
 # Restore stack pointer
    popq %rbp
 # Restore base pointer
    ret
 # Return to caller

cannot_concatenate:
    pushq %rax
 # Save RAX
    subq $8, %rsp
 # Align stack to 16 bytes
    lea len_over(%rip), %rdi
 # RDI = address of "cannot concatenate strings!\n"
    xor %eax, %eax
 # Clear EAX
    call printf
 # Print message
    addq $8, %rsp
 # Restore stack
    popq %rax
 # Restore RAX
    movq %rbp, %rsp
 # Restore stack pointer
    popq %rbp
 # Restore base pointer
    ret
 # Return to caller
