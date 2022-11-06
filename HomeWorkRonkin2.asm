format PE CONSOLE
include 'C:\FASM\INCLUDE\win32ax.inc'

entry start

section '.data?' data readable writeable
   x1 dd 6 dup(?) ;Объявление неинициализированного массива x1 из 6 элемнетов, каждый размером 4 байта
   size_x1 = $-x1 ;Размер массива x1
   x2 dw 6 dup(?)  ;Объявление неинициализированного массива x2 из 6 элемнетов, каждый размером 2 байта
   size_x2 = $-x2  ;Размер массива x2
   A dw ?   ;Объявление неинициализированной переменной A размером 2 байта


section '.data' data readable
   array1    dw 31,32,5,4,5,6 ;Объявление инициализированного массива array1 из 6 элементов, каждый размером 2 байта
   size_a1 =  $ - array1  ;Размер массива array1

   array2    db 1,2,3,4,5,6 ;Объявление инициализированного массива array2 из 6 элементов, каждый размером 1 байт
   size_a2 =  $ - array2  ;Размер массива array2

   array3 dw 7 dup(3) ;Объявление инициализированного массива array3 из 7 троек, каждый элемент размером 2 байта
   size_a3 =  $ - array3  ;Размер массива array3

   array4 dw 2 dup(71,10,11) ;Объявление инициализированного массива array3 из 2 элементов, каждый элемент размером 2 байта
   size_a4 =  $ - array4  ;Размер массива array4


   size_of_dd = 4 ;Объявление переменной со значением 4.

section '.msg' data readable
   msg_d db ' %d ', 0Dh, 0Ah,0 ;Определяется переменная для числового значения
   msg_s db 0Dh, 0Ah,' %s ',  0Dh, 0Ah,0 ;Определяется переменная для строки

section '.code' code readable executable

macro print_array arr, arr_size, word_size ;Объявление макроса для вывода массива на экран с 3 входными параметрами
{
     mov ebx,0 ;Помещаем в регистр ebx 0
     @@: ;Создание анонимной метки
       cinvoke printf,  ' %d ', [arr+ebx],0 ;Вывод на экран значения элемента массива arr
       add ebx,word_size   ;Сложение значения регистра ebx и значения в переменной word_size
       cmp ebx , arr_size ;Сравнение значения регистра ebx и размера массива 
       jne @b ;Если значения не равны, переход к предыдущей метке 
}

start:
     cinvoke printf,  msg_s,'1 part',0  ;Вывод строки на экран
     cinvoke printf,  msg_d,  size_a1  ;Вывод размера массива array1 на экран

     cinvoke printf,  msg_d, size_a2,0 ;Вывод размера массива array2 на экран 
     cinvoke printf,  msg_d, size_x1,0  ;Вывод размера массива x1 на экран

     cinvoke printf,  msg_d, [array1+0],0 ;Вывод 1-ого элемента массива array1 на экран
     cinvoke printf,  msg_d, [array1+2],0 ;Вывод 2-ого элемента массива array1 на экран
     cinvoke printf,  msg_d, [array1+4],0 ;Вывод 3-го элемента массива array1 на экран

     cinvoke printf,  msg_s,'2 part',0  ;Вывод строки на экран
     xor ebx,ebx  ;Обнуление регистра ebx
     @@: ;Создание анонимной метки
       cinvoke printf,  ' %d ',  [array3+ebx],0  ;Вывод на экран значения элемента массива array3
       add ebx,2 ;Сложение значения регистра ebx и 2
       cmp ebx , size_a3  ;Сравнение регистра ebx и размера массива array3
       jne @b  ;Если значения не равны, переход к предыдущей метке

     print_array array4,size_a4,2 ;Вызов макросса print_array с передачей ему 3 параметров

     cinvoke printf,  msg_s,'3 part',0 ;Вывод строки на экран
     mov ax, [array1] ;В регистр ax помещается 1-ое значение элемента массива
     add ax, 2 ;Сложение значения регистра ax с 2
     mov [x2], ax ;В массив x2 помещается значение регистра ax
     print_array x2, size_x2, 2 ;Вызов макросса print_array с передачей ему 3 параметров

     cinvoke printf,  msg_s,'4 part',0 ;Вывод строки на экран
     print_array x1, size_x1, size_of_dd ;Вызов макросса print_array с передачей ему 3 параметров

     xor ebx,ebx ;Обнуление регистра ebx
     @@: ;Созание анонимной метки
       mov [x1+ebx],ebx  ;Помещаем в элемент массива x1 значение регистра ebx
       add ebx,size_of_dd ;Сложение значения регистра ebx и значения переменной size_of_dd = 4
       cmp ebx , size_x1 ;Сравнение значения регистра ebx и значения размера массива x1
       jne @b   ;Если значения не равны, переход на предыдущую метку

     cinvoke printf,  msg_s,'',0  ;Вывод пустой строки на экран
     print_array x1, size_x1, size_of_dd ;Вызов макросса print_array с передачей ему 3 параметров

     cinvoke printf,  msg_s,'5 part',0  ;Вывод строки на экран
     cinvoke printf,  msg_s,' Enter number',0 ;Вывод строки на экран
     cinvoke scanf,   ' %d', A    ;Ввод значения переменной A
     mov eax, dword [A] ;Помещаем значение переменной A в регистр eax
     mov [x2+2], ax  ;Помещаем значение регистра ax во 2-ой элемент массива x2
     print_array x2, size_x2, 2 ;Вызов макросса print_array с передачей ему 3 параметров



     invoke  sleep, 5000     ; 5 sec. delay

     invoke  exit, 0
     ret




section '.idata' import data readable
 
 library msvcrt,'MSVCRT.DLL',\
    kernel32,'KERNEL32.DLL'
 
 import kernel32,\
    sleep,'Sleep'
 
 import msvcrt,\
    puts,'puts',\
    scanf,'scanf',\
    printf,'printf',\
    lstrlen,'lstrlenA',\
    exit,'exit'