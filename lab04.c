int read(int __fd, const void *__buf, int __n){
    int ret_val;
  __asm__ __volatile__(
    "mv a0, %1           # file descriptor\n"
    "mv a1, %2           # buffer \n"
    "mv a2, %3           # size \n"
    "li a7, 63           # syscall write code (63) \n"
    "ecall               # invoke syscall \n"
    "mv %0, a0           # move return value to ret_val\n"
    : "=r"(ret_val)  // Output list
    : "r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
  return ret_val;
}

void write(int __fd, const void *__buf, int __n){
  __asm__ __volatile__(
    "mv a0, %0           # file descriptor\n"
    "mv a1, %1           # buffer \n"
    "mv a2, %2           # size \n"
    "li a7, 64           # syscall write (64) \n"
    "ecall"
    :   // Output list
    :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
}

void exit(int code){
  __asm__ __volatile__(
    "mv a0, %0           # return code\n"
    "li a7, 93           # syscall exit (64) \n"
    "ecall"
    :   // Output list
    :"r"(code)    // Input list
    : "a0", "a7"
  );
}

void _start()
{
  int ret_code = main();
  exit(ret_code);
}

void hex_code(int val){
    char hex[11];
    unsigned int uval = (unsigned int) val, aux;

    hex[0] = '0';
    hex[1] = 'x';
    hex[10] = '\n';

    for (int i = 9; i > 1; i--){
        aux = uval % 16;
        if (aux >= 10)
            hex[i] = aux - 10 + 'A';
        else
            hex[i] = aux + '0';
        uval = uval / 16;
    }
    write(1, hex, 11);
}

#define STDIN_FD  0
#define STDOUT_FD 1

int montarnumero(int n1, int n2, int n3, int n4){ //funcao para montar o numero pegando os bits mais e menos significativos etc
    int resultado= 0;

    resultado |= (n1 & 0xFF); //8 bits menos significantes e os coloca de 0-7
    resultado |= (n2 &0xFF)<<8; //8 bits menos significantes e os coloca de 8-15
    resultado |= ((n4>>24)&0xFF)<<16; //8 bits mais significantes e os coloca de 16-23
    resultado |= ((n3>>24&0xFF))<<24; //8 bits mais significantes e os coloca de 24-31

    return resultado;
}

int main(){
    char entrada[48];
    int n = read(STDIN_FD, entrada, 48);
    int numeros[8];
    int i, sinal, valor, pos=0;
    for(i = 0; i < 8; i++){ //transforma as strings em inteiros 
        sinal = (entrada[pos] == '-') ? -1 : 1;
        valor = 0;

        for(int j = 1; j <= 4; j++){
            valor = valor * 10 + (entrada[pos + j] - '0');
        }

        numeros[i] = sinal * valor; 
        pos += 6;
    }

    int n1 = numeros[0]&numeros[1];
    int n2= numeros[2]|numeros[3];
    int n3= numeros[4]^numeros[5];
    int n4= ~(numeros[6]&numeros[7]);

    int resultado = montarnumero(n1, n2, n3, n4);
    hex_code(resultado);

    return 0;
}

