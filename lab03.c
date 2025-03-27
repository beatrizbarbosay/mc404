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

void unsignedIntParaString(unsigned int num, char *str) { //para lidar com numeros unsigned
  int i = 0;
  if (num == 0) {
    str[i++] = '0';
  }
  while (num > 0) {
    str[i++] = (num % 10) + '0';
    num /= 10;
  }
  str[i] = '\0';
  for (int j = 0; j < i / 2; j++) {
    char temp = str[j];
    str[j] = str[i - j - 1];
    str[i - j - 1] = temp;
  }
}

int binarioParaDecimal(const char binario[]) { //comando1
  unsigned int decimal = 0;
  for (int i = 0; i < 32; i++) { //converte cada bit para decimal
    decimal = (decimal << 1) | (binario[i] - '0');//shifta o valor de decimal para a esquerda e adiciona o valor do bit
  }
  if (binario[0] == '1') { //se o número for negativo, inverte os bits e soma 1. obs: complemento 2
    decimal = -(~decimal + 1);
  }  
  return (int)decimal;
}


unsigned int binarioParaDecimalTrocado(const char binario[33]) { //comando 2 e 6
    //string binária para unsigned int
  unsigned int num = 0;
  for (int i = 0; i < 32; i++) {
    num = (num << 1) | (binario[i] - '0');
  }
  //troca a ordem dos bytes
  unsigned int trocado = ((num >> 24) & 0xFF) | ((num >> 8)  & 0xFF00) | ((num << 8)  & 0xFF0000) | ((num << 24) & 0xFF000000); 
  return trocado;
}

void decimalparahexa(int num, char *str) {
  unsigned int valor = (unsigned int) num;
  str[0] = '0';
  str[1] = 'x';

  int inicio = 2;
  int encontrou = 0; //para não printar os zeros a esquerda

  for (int i = 0; i < 8; i++) { //converte cada 4 bits para hexadecimal
    int digito = (valor >> (28 - i * 4)) & 0xf; //desloca os bits e extrai o ultimos 4 com o comando &0xF
    if (digito || digito || i == 7) { 
      str[inicio++] = (digito < 10) ? (digito + '0') : (digito - 10 + 'a');
      digito = 1;
      }
    }
    
    str[inicio] = '\0';
}

void decimalparaoctal(int num, char *str) {
  unsigned int valor = (unsigned int) num;  
  str[0] = '0';  
  str[1] = 'o';

  int inicio = 2;
  int encontrou = 0;

  for (int i = 10; i >= 0; i--) { // percorre grupos de 3 bits)
    int digito = (valor >> (i * 3)) & 0x7;  // extrai 3 bits

    if (digito || encontrou || i == 0) {  
      str[inicio++] = digito + '0'; 
      encontrou = 1;
    }
  }

  str[inicio] = '\0';
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
  unsigned int resultadoNaoAssinado = binarioParaDecimalTrocado(entradabinaria);

  char hexa[11];
  decimalparahexa(resultado, hexa);

  char octal[12];
  decimalparaoctal(resultado, octal);

  unsigned int resultadotrocado= binarioParaDecimalTrocado(entradabinaria);
  
  char resultadoStr[12];
  intParaString(resultado, resultadoStr);
  char resultadoStrNaoAssinado[12];
  unsignedIntParaString(resultadoNaoAssinado, resultadoStrNaoAssinado);
  char resultadoStrTrocado[12];
  intParaString(resultadotrocado, resultadoStrTrocado);
  
  int len = 0;
  while (resultadoStr[len] != '\0') len++; 
  int lenTrocado = 0;
  while (resultadoStrTrocado[lenTrocado] != '\0') lenTrocado++; 
  int lenNaoAssinado = 0;
  while (resultadoStrNaoAssinado[lenNaoAssinado] != '\0') lenNaoAssinado++; 

  
  write(STDOUT_FD, resultadoStr, len);
  write(STDOUT_FD, "\n", 1);

  write(STDOUT_FD, resultadoStrNaoAssinado, lenNaoAssinado);
  write(STDOUT_FD, "\n", 1);

  write(STDOUT_FD, hexa, 10);
  write(STDOUT_FD, "\n", 1);

  write(STDOUT_FD, octal, 11);
  write(STDOUT_FD, "\n", 1);

  write(STDOUT_FD, resultadoStrTrocado, lenTrocado);
  write(STDOUT_FD, "\n", 1);


  
  return 0;
}