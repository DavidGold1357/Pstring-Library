   #David Goldstein 331010835
    .section .rodata
scanf_fmt:
    .string "%d %d"
 # Format string for scanf

invalid_option:
    .string "invalid option!\n"
 # Printed when the chosen option is invalid

print_len:
    .string "first pstring length: %d, second pstring length: %d\n"
 # Format for printing two lengths

print_swap:
    .string "length: %d, string: %s\n"
 # Format for printing length and string

    .section .text
    .globl run_func

run_func:
    pushq %rbp
 # Save old base pointer

    movq %rsp, %rbp
 # Set new base pointer

    subq $8, %rsp
 # Align stack to 16 bytes

    cmp $31, %edi
 # Compare option with 31 (pstrlen)

    je call_pstrlen
 # If equal, jump to call_pstrlen

    cmp $33, %edi
 # Compare option with 33 (swapCase)

    je call_swapCase
 # If equal, jump to call_swapCase

    cmp $34, %edi
 # Compare option with 34 (pstrijcpy)

    je call_pstrijcpy
 # If equal, jump to call_pstrijcpy

    cmp $37, %edi
 # Compare option with 37 (pstrcat)

    je call_pstrcat
 # If equal, jump to call_pstrcat

    pushq %rax
 # Save RAX

    pushq %rdi
 # Save RDI

    lea invalid_option(%rip), %rdi
 # RDI = address of invalid message

    xor %eax, %eax
 # Clear EAX

    call printf
 # Print invalid option message

    popq %rdi
 # Restore RDI

    popq %rax
 # Restore RAX

    jmp done
 # Jump to done

call_pstrlen:
    movq %rsi, %rdi
 # RDI = first Pstring pointer

    call pstrlen
 # Call pstrlen for first Pstring

    movb %al, %bl
 # BL = length of first Pstring

    movq %rdx, %rdi
 # RDI = second Pstring pointer

    call pstrlen
 # Call pstrlen for second Pstring

    movb %al, %cl
 # CL = length of second Pstring

    lea print_len(%rip), %rdi
 # RDI = address of print_len format

    movzbl %bl, %esi
 # ESI = first length

    movzbl %cl, %edx
 # EDX = second length

    xor %eax, %eax
 # Clear EAX

    call printf
 # Print the lengths

    jmp done
 # Jump to done

call_swapCase:
    movq %rsi, %rdi
 # RDI = first Pstring pointer

    call swapCase
 # Call swapCase on first Pstring

    movq %rax, %r12
 # R12 = pointer to swapped first Pstring

    movq %rdx, %rdi
 # RDI = second Pstring pointer

    call swapCase
 # Call swapCase on second Pstring

    movq %rax, %r13
 # R13 = pointer to swapped second Pstring

    movzbl (%r12), %esi
 # ESI = length of first swapped Pstring

    lea 1(%r12), %rdx
 # RDX = address of first swapped string chars

    lea print_swap(%rip), %rdi
 # RDI = print_swap format

    xor %eax, %eax
 # Clear EAX

    call printf
 # Print first swapped string

    movzbl (%r13), %esi
 # ESI = length of second swapped Pstring

    lea 1(%r13), %rdx
 # RDX = address of second swapped string chars

    lea print_swap(%rip), %rdi
 # RDI = print_swap format

    xor %eax, %eax
 # Clear EAX

    call printf
 # Print second swapped string

    jmp done
 # Jump to done

call_pstrijcpy:
    pushq %rsi
 # Save RSI

    pushq %rdx
 # Save RDX

    subq $16, %rsp
 # Allocate 16 bytes

    subq $8, %rsp
 # Allocate 8 more bytes for alignment

    lea scanf_fmt(%rip), %rdi
 # RDI = address of scanf_fmt

    lea (%rsp), %rsi
 # RSI = address for i

    lea 8(%rsp), %rdx
 # RDX = address for j

    xor %eax, %eax
 # Clear EAX

    call scanf
 # Read i and j

    movl (%rsp), %r8d
 # R8d = i

    movl 8(%rsp), %r9d
 # R9d = j

    addq $8, %rsp
 # Restore stack pointer

    addq $16, %rsp
 # Restore stack pointer

    popq %rdx
 # RDX = src

    popq %rsi
 # RSI = dst

    movq %rdx, %r12
 # R12 = src pointer

    movq %rsi, %rdi
 # RDI = dst

    movq %rdx, %rsi
 # RSI = src

    movl %r8d, %edx
 # EDX = i

    movl %r9d, %ecx
 # ECX = j

    call pstrijcpy
 # Call pstrijcpy(dst, src, i, j)

    movq %rax, %rbx
 # RBX = new dst pointer

    movzbl (%rbx), %edi
 # EDI = new dst length

    movl %edi, %esi
 # ESI = length as int

    lea 1(%rbx), %rdx
 # RDX = new dst chars

    lea print_swap(%rip), %rdi
 # RDI = print_swap format

    xor %eax, %eax
 # Clear EAX

    call printf
 # Print new dst

    movzbl (%r12), %edi
 # EDI = src length

    movl %edi, %esi
 # ESI = length as int

    lea 1(%r12), %rdx
 # RDX = src chars

    lea print_swap(%rip), %rdi
 # RDI = print_swap format

    xor %eax, %eax
 # Clear EAX

    call printf
 # Print original src

    jmp done
 # Jump to done

call_pstrcat:
    movq %rdx, %r12
 # R12 = src pointer

    movq %rsi, %rdi
 # RDI = dst

    movq %r12, %rsi
 # RSI = src

    call pstrcat
 # Call pstrcat(dst, src)

    movq %rax, %rbx
 # RBX = new dst pointer

    movzbl (%rbx), %edi
 # EDI = new dst length

    movl %edi, %esi
 # ESI = length as int

    lea 1(%rbx), %rdx
 # RDX = new dst chars

    lea print_swap(%rip), %rdi
 # RDI = print_swap format

    xor %eax, %eax
 # Clear EAX

    call printf
 # Print new dst

    movzbl (%r12), %edi
 # EDI = src length

    movl %edi, %esi
 # ESI = length as int

    lea 1(%r12), %rdx
 # RDX = src chars

    lea print_swap(%rip), %rdi
 # RDI = print_swap format

    xor %eax, %eax
 # Clear EAX

    call printf
 # Print original src

    jmp done
 # Jump to done

done:
    movq %rbp, %rsp
 # Restore stack pointer

    popq %rbp
 # Restore base pointer

    ret
 # Return to caller
