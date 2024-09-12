.text
main:
jal selectionSort
j terminate
#s0 -> i
#s1 -> min_idx
#selection sort has to load its own return address at the end 

selectionSort:
 addi sp, sp, -20 #allocates space for 5
 sw ra, 0(sp) #stores ra 
 sw s0, 4(sp) #stores s0-s3
 sw s1, 8(sp) 
 sw s2, 12(sp)
 sw s3, 16(sp)
 la a0, array #----------------------------------------#
 li a1, 8     #----------------------------------------#
 add s0, x0, x0 #s0 = i
 add s1, x0, x0 #s1 = min_idx
 add s2, x0, a0 #s2 = &arr[0]
 add s3, x0, a1 #s3 = n

 for: addi t0, s3, -1 #t0 = n-1 (recalculated each iteration)
  bge s0, t0, endloop #t0 used in comparison(can be overridden after), jump to end when i>= n-1
 
  slli t1, s0, 2 #t1 = 4i
  add s4, s2, t1 #s4 = &arr[i] = BA + t1
  sub t2, s3, s0 #t2 = n-i
  add a0, s4, x0 #a0 = &arr[i] for findMinimum
  add a1, t2, x0 #a1 = n - i for findMinimum
  jal ra, findMinimum #jump to findMinimum
  add s1, x0, a0 #takes a0 return from the function and makes that the new min_idx value
  
 if: beq s1, x0, endif #if min_idx == 0 go to endif
  add t3, s0, s1 #t3 = min_idx + i
  slli t3, t3, 2 #t3 = 4(t3)
  add a2, t3, s2 #a2 = BA+t3 = &arr[min_idx + i]
  slli t4, s0, 2 #t4 = 4i
  add a3, s2, t4 #a3 = &arr[i] = BA + t4
  jal ra, swap
  
 endif:
  addi s0, s0, 1 #i++ ----------
  j for
  
 endloop:
  lw ra, 0(sp)
  lw s0, 4(sp) #stores s0-s3
  lw s1, 8(sp) 
  lw s2, 12(sp)
  lw s3, 16(sp)
  jr ra

findMinimum: 
  add s1, x0, x0 #s1 = min_idx = 0
  slli t1, s1, 2 #t1(used to hold 4i in parent function) = 4 * min_idx
  add t1, t1, a0 # t1 = new BA + 4 * min_idx
  lw t1, 0(t1) # t1 = arr[min_idx] = min_E
  addi t5, x0, 1 #t5 = i = 1 
 
 for2: bge t5, a1, endfor2 #i (t5) >= n-i (a1), endloop 
  slli t0, t5, 2 #t0 = 4i
  add t0, a0, t0 #t0 = &arr[i] calculated from new BA
  lw t0, 0(t0) #t0 = arr[i]

  if2: bge t0, t1, endif2 #arr[i] >= minE -> endif
   add s1, x0, t5 #min_idx = i
   slli t1, s1, 2 #t1 = 4 * min_idx
   add t1, s2, t1 #t1 = &arr[min_idx]
   lw t1, 0(t1) #t1: minE = arr[min_idx] 
  endif2:
   addi t5, t5, 1 #i++
   j for2
   
endfor2: 
 add a0, s1, x0 #return min_idx
 jr ra

swap: 
 lw t6, 0(a2) #t6 = arr[min_idx + i]  --- temp done 
 lw t1, 0(a3) #t1 = *yp
 sw t1, 0(a2) #stores *yp at the address given by xp
 sw t6, 0(a3) #stores temp into *yp
 addi a4, a4, 1
 jr ra
 
terminate:

.data #----------#
 array: #-----------#
  .word 212, 9, 23, 66, 87, 94, 13, 4 #---------#
