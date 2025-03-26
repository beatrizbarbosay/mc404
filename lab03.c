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

void write(int __fd, const void *__buf, int __n)
{
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

void exit(int code)
{
  __asm__ __volatile__(
    "mv a0, %0           # return code\n"
    "li a7, 93           # syscall exit (64) \n"
    "ecall"
    :   // Output list
    :"r"(code)    // Input list
    : "a0", "a7"
  );
}

void _start() {
  int ret_code;
  asm volatile (
    "call main\n"
    "mv %0, a0\n"
    : "=r"(ret_code)
    :
    : "a0"
  );
  exit(ret_code);
}

#define STDIN_FD  0
#define STDOUT_FD 1

int main();

int binarioParaDecimal(const char binario[]) {
  unsigned int decimal = 0;
  for (int i = 0; i < 32; i++) { //converte cada bit para decimal
    decimal = (decimal << 1) | (binario[i] - '0');//shifta o valor de decimal para a esquerda e adiciona o valor do bit
  }
  if (binario[0] == '1') { //se o número for negativo, inverte os bits e soma 1. obs: complemento 2
    decimal = -(~decimal + 1);
  }  
  return (int)decimal;
}

void intParaString(int num, char *str) { //para poder printar
  int i = 0;
  int negativo = 0;
  
  if (num < 0) { //trata negativos e retorna o absoluto
    negativo = 1;
    num = -num;
  }
  if (num == 0) { //se o numero for 0
    str[i] = '0';
    i++;
  }
  while (num > 0) { //retorna a string invertida
    str[i] = (num % 10) + '0';
    num /= 10;
    i++;
  }
  if (negativo) { //se for negativo, adiciona o sinal
    str[i] = '-';
    i++;
  }
  str[i] = '\0';
  for (int j = 0; j < i / 2; j++) { //inverte a string
    char temp = str[j];
    str[j] = str[i - j - 1];
    str[i - j - 1] = temp;
  }
}

int main() {
  char entradabinaria[33];
  int n = read(STDIN_FD, entradabinaria, 33);
  
  // Garante que a string está terminada corretamente
  if (n > 0 && entradabinaria[n-1] == '\n') {
    entradabinaria[n-1] = '\0';
    n--;
  } else {
    entradabinaria[n] = '\0';
  }
  
  int resultado = binarioParaDecimal(entradabinaria);
  
  char resultadoStr[12];
  intParaString(resultado, resultadoStr);
  
  int len = 0;
  while (resultadoStr[len] != '\0') len++; //calcula o tamanho da string
  
  write(STDOUT_FD, resultadoStr, len);
  write(STDOUT_FD, "\n", 1);
  
  return 0;
}